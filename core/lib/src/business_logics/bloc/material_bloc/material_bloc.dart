import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/material.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/services/material_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';

part 'material_event.dart';
part 'material_state.dart';

// bloc
class MaterialBloc extends Bloc<MaterialEvent, MaterialState> {
  MaterialBloc() : super(MaterialIdleState());

  final MaterialService _materialServices = serviceLocator<MaterialService>();

  @override
  Stream<MaterialState> mapEventToState(MaterialEvent event) async* {
    if (event is AddMaterial) {
      yield* _mapAddMaterialToState(event);
    } else if (event is EditMaterial) {
      yield* _mapEditMaterialToState(event);
    } else if (event is DeleteMaterial) {
      yield* _mapDeleteMaterialToState(event);
    }
  }

  Stream<MaterialState> _mapAddMaterialToState(AddMaterial event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      ResponseResult result =
          await _materialServices.submitMaterial(_material(event));
      if (result.status == true) {
        yield _success(result);
      } else {
        yield _error(result);
      }
    } else {
      yield _nullValueError();
    }
  }

  Stream<MaterialState> _mapEditMaterialToState(EditMaterial event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      ResponseResult result =
          await _materialServices.editMaterialByCode(_material(event));
      await Future.delayed(Duration(seconds: 1));
      if (result.status == true) {
        yield _success(result);
      } else {
        yield _error(result);
      }
    } else {
      yield _nullValueError();
    }
  }

  Stream<MaterialState> _mapDeleteMaterialToState(DeleteMaterial event) async* {
    Map<String, String> scode = {'mcode': event.mcode};
    ResponseResult result = await _materialServices.deleteMaterial(scode);
    if (result.status == true) {
      yield _success(result);
    } else {
      yield _error(result);
    }
  }

  bool _isEventAttributeIsNotNull(var event) {
    if (event.mpriceperunit != '' &&
        event.mcode != '' &&
        event.mname != '' &&
        event.munit != '') {
      return true;
    }
    return false;
  }

  Material _material(var event) {
    return Material(
      mname: event.mname,
      mcode: event.mcode,
      munit: event.munit,
      mpriceperunit: event.mpriceperunit,
    );
  }

  MaterialState _success(ResponseResult result) {
    return MaterialSuccess(result.status, result.message);
  }

  MaterialState _loading() {
    return MaterialLoading(true, "Uploading...");
  }

  // MaterialState _errorAndClear(ResponseResult result) {
  //   return MaterialErrorAndClear(result.status, result.message);
  // }

  MaterialState _error(ResponseResult result) {
    return MaterialError(result.status, result.message);
  }

  MaterialState _nullValueError() {
    return MaterialError(false, 'please fill required fields');
  }
}
