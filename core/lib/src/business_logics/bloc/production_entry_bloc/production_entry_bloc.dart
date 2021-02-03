import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/src/business_logics/models/production.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/services/production_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';

part 'production_entry_event.dart';

part 'production_entry_state.dart';

//TODO: start here find and replace MP to production
class ProductionEntryBloc extends Bloc<ProductionEvent, ProductionEntryState> {
  ProductionEntryBloc() : super(ProductionIdle());

  final ProductionService _pServices = serviceLocator<ProductionService>();

  @override
  Stream<ProductionEntryState> mapEventToState(ProductionEvent event) async* {
    if (event is ProductionEntry) {
      yield* _mapAddProductionToState(event);
    } else if (event is EditProduction) {
      yield* _mapEditProductionToState(event);
    } else if (event is DeleteProduction) {
      yield* _mapDeleteProductionToState(event);
    }
  }

  bool _isEventAttributeIsNotNull(var event) {
    if (event.ecode != '' &&
        event.sps != '' &&
        event.pdcode != '' &&
        event.nosps != '' &&
        event.nos != '' &&
        event.date != '' &&
        event.salary != '' &&
        // event.remarks != '' &&
        event.pcode != '') {
      return true;
    }
    return false;
  }

  ProductionEntryState _success(ResponseResult result) {
    return ProductionSuccess(result.status, result.message);
  }

  ProductionEntryState _loading() {
    return ProductionLoading(true, "Uploading...");
  }

  // ProductionState _errorAndClear(ResponseResult result) {
  //   return ProductionErrorAndClear(result.status, result.message);
  // }

  ProductionEntryState _error(ResponseResult result) {
    return ProductionError(result.status, result.message);
  }

  ProductionEntryState _nullValueError() {
    return ProductionError(false, 'please fill required fields');
  }

  Production _production(var event) {
    return Production(
      ecode: event.ecode,
      sps: event.sps,
      pdcode: event.pdcode,
      nosps: event.nosps,
      nos: event.nos,
      date: event.date,
      salary: event.salary,
      remarks: event.remarks,
      pcode: event.pcode,
    );
  }

  Stream<ProductionEntryState> _mapAddProductionToState(
      ProductionEntry event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      Production p = _production(event);
      ResponseResult result = await _pServices.submitProduction(p);
      if (result.status == true) {
        yield _success(result);
      } else {
        yield _error(result);
      }
    } else {
      yield _nullValueError();
    }
  }

  Stream<ProductionEntryState> _mapEditProductionToState(
      EditProduction event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      Production mp = _production(event);
      ResponseResult result = await _pServices.editProductionByCode(mp);
      await Future.delayed(Duration(seconds: 1));
      if (result.status == true) {
        yield _success(result);
      } else {
        yield _error(result);
      }
    } else {
      yield _nullValueError();
    }

// Stream<ProductionState> _mapDeleteProductionToState(DeleteProduction event) async* {
//   Map<String:  event String> scode = {'mcode': event.mcode};
//   ResponseResult result = await _pServices.deleteProduction(scode);
//   if (result.status == true) {
//     yield _success(result);
//   } else {
//     yield _error(result);
//   }
// }
  }

  Stream<ProductionEntryState> _mapDeleteProductionToState(
      DeleteProduction deleteProduction) async* {
    Map<String, String> pdcode = {'mpcode': deleteProduction.pdcode};
    ResponseResult result = await _pServices.deleteProduction(pdcode);
    if (result.status == true) {
      yield _success(result);
    } else {
      yield _error(result);
    }
  }
}