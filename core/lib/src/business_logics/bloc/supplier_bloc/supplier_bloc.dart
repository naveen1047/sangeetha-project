import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/supplier.dart';
import 'package:core/src/business_logics/util/util.dart';
import 'package:core/src/services/supplier_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';

part 'supplier_event.dart';
part 'supplier_state.dart';

// bloc
class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  SupplierBloc() : super(SupplierIdleState());

  final SupplierService _supplierServices = serviceLocator<SupplierService>();

  // get date
  String get getDateInFormat => generateDate();

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  Stream<SupplierState> mapEventToState(SupplierEvent event) async* {
    if (event is AddSupplier) {
      yield* _mapAddSupplierToState(event);
    } else if (event is EditSupplier) {
      yield* _mapEditSupplierToState(event);
    } else if (event is DeleteSupplier) {
      yield* _mapDeleteSupplierToState(event);
    }
  }

  Stream<SupplierState> _mapAddSupplierToState(AddSupplier event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      ResponseResult result =
          await _supplierServices.submitSupplier(_supplier(event));
      if (result.status == true) {
        yield _success(result);
      } else {
        yield _errorAndClear(result);
      }
    } else {
      yield _nullValueError();
    }
  }

  Stream<SupplierState> _mapEditSupplierToState(EditSupplier event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      ResponseResult result =
          await _supplierServices.editSupplierByCode(_supplier(event));
      await Future.delayed(Duration(seconds: 1));
      if (result.status == true) {
        yield _success(result);
      } else {
        yield _errorAndClear(result);
      }
    } else {
      yield _nullValueError();
    }
  }

  Stream<SupplierState> _mapDeleteSupplierToState(DeleteSupplier event) async* {
    Map<String, String> scode = {'scode': event.scode};
    ResponseResult result = await _supplierServices.deleteSupplier(scode);
    if (result.status == true) {
      yield _success(result);
    } else {
      yield _errorAndClear(result);
    }
  }

  bool _isEventAttributeIsNotNull(var event) {
    if (event.sname != '' && event.snum != '' && event.saddress != '') {
      return true;
    } else {
      return false;
    }
  }

  Supplier _supplier(var event) {
    return Supplier(
      sname: event.sname,
      saddate: event.saddate,
      saddress: event.saddress,
      scode: event.scode,
      snum: event.snum,
    );
  }

  SupplierState _loading() {
    return SupplierLoading(true, "Uploading..");
  }

  SupplierState _error(ResponseResult result) {
    return SupplierError(result.status, result.message);
  }

  SupplierState _success(ResponseResult result) {
    return SupplierSuccess(result.status, result.message);
  }

  SupplierState _errorAndClear(ResponseResult result) {
    return SupplierErrorAndClear(result.status, result.message);
  }

  SupplierState _nullValueError() {
    return SupplierError(false, 'please fill required fields');
  }
}
