import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/material.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/services/material_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';

// event
abstract class MaterialEvent extends Equatable {
  const MaterialEvent();

  @override
  List<Object> get props => [];
}

class AddMaterial extends MaterialEvent {
  final String mname;
  final String mcode;
  final String munit;
  final String mpriceperunit;

  AddMaterial({
    this.mname,
    this.mcode,
    this.munit,
    this.mpriceperunit,
  });

  @override
  List<Object> get props => [
        mname,
        mcode,
        munit,
        mpriceperunit,
      ];
}

class EditMaterial extends MaterialEvent {
  final String mname;
  final String mcode;
  final String munit;
  final String mpriceperunit;

  EditMaterial({this.mname, this.mcode, this.munit, this.mpriceperunit});

  @override
  List<Object> get props => [
        mname,
        mcode,
        munit,
        mpriceperunit,
      ];
}

class DeleteMaterial extends MaterialEvent {
  final String mcode;

  DeleteMaterial({
    this.mcode,
  });

  @override
  List<Object> get props => [];
}

// state
abstract class MaterialState {
  const MaterialState();
}

class MaterialIdleState extends MaterialState {}

class MaterialSuccess extends MaterialState {
  final bool status;
  final String message;

  MaterialSuccess(this.status, this.message);
}

class MaterialError extends MaterialState {
  final bool status;
  final String message;

  MaterialError(this.status, this.message);
}

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
    if (event.mpriceperunit != '' &&
        event.mcode != '' &&
        event.mname != '' &&
        event.munit != '') {
      ResponseResult result = await _materialServices.submitMaterial(
        Material(
          mname: event.mname,
          mcode: event.mcode,
          munit: event.munit,
          mpriceperunit: event.mpriceperunit,
        ),
      );
      if (result.status == true) {
        yield MaterialSuccess(result.status, result.message);
      } else {
        yield MaterialError(result.status, result.message);
      }
    } else {
      yield MaterialError(false, 'please fill required fields');
    }
  }

  Stream<MaterialState> _mapEditMaterialToState(EditMaterial event) async* {
    if (event.mpriceperunit != '' &&
        event.mcode != '' &&
        event.mname != '' &&
        event.munit != '') {
      ResponseResult result = await _materialServices.editMaterialByCode(
        Material(
          mname: event.mname,
          mcode: event.mcode,
          munit: event.munit,
          mpriceperunit: event.mpriceperunit,
        ),
      );
      if (result.status == true) {
        yield MaterialSuccess(result.status, result.message);
      } else {
        yield MaterialError(result.status, result.message);
      }
    } else {
      yield MaterialError(false, 'please fill required fields');
    }
  }

  Stream<MaterialState> _mapDeleteMaterialToState(DeleteMaterial event) async* {
    Map<String, String> scode = {'mcode': event.mcode};
    print(scode.toString());
    ResponseResult result = await _materialServices.deleteMaterial(scode);
    if (result.status == true) {
      yield MaterialSuccess(result.status, result.message);
    } else {
      yield MaterialError(result.status, result.message);
    }
  }
}
