import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/material_purchase.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/services/material_purchase_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';

part 'mp_entry_event.dart';

part 'mp_entry_state.dart';

// bloc
class MPBloc extends Bloc<MPEvent, MPState> {
  MPBloc() : super(MPIdle());

  final MaterialPurchaseService _mpServices =
      serviceLocator<MaterialPurchaseService>();

  @override
  Stream<MPState> mapEventToState(MPEvent event) async* {
    if (event is UploadMPEntry) {
      yield* _mapAddMPToState(event);
    }
    // else if (event is EditMP) {
    //   yield* _mapEditMPToState(event);
    // } else if (event is DeleteMP) {
    //   yield* _mapDeleteMPToState(event);
    // }
  }

  Stream<MPState> _mapAddMPToState(UploadMPEntry event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      MaterialPurchase mp = _materialPurchase(event);
      ResponseResult result = await _mpServices.submitMaterialPurchase(mp);
      if (result.status == true) {
        yield _success(result);
      } else {
        yield _error(result);
      }
    } else {
      yield _nullValueError();
    }
  }

// Stream<MPState> _mapEditMPToState(EditMP event) async* {
//   if (_isEventAttributeIsNotNull(event)) {
//     yield _loading();
//     ResponseResult result = await _MPServices.editMPByCode(_MP(event));
//     await Future.delayed(Duration(seconds: 1));
//     if (result.status == true) {
//       yield _success(result);
//     } else {
//       yield _error(result);
//     }
//   } else {
//     yield _nullValueError();
//   }

// Stream<MPState> _mapDeleteMPToState(DeleteMP event) async* {
//   Map<String:  event String> scode = {'mcode': event.mcode};
//   ResponseResult result = await _MPServices.deleteMP(scode);
//   if (result.status == true) {
//     yield _success(result);
//   } else {
//     yield _error(result);
//   }
// }

  bool _isEventAttributeIsNotNull(var event) {
    if (event.mpcode != '' &&
            event.scode != '' &&
            event.scode != null &&
            event.date != '' &&
            event.billno != '' &&
            event.mcode != '' &&
            event.mcode != null &&
            event.quantity != '' &&
            event.unitprice != '' &&
            event.price != ''
        // &&
        // event.remarks != ''
        ) {
      return true;
    }
    return false;
  }

  MaterialPurchase _materialPurchase(UploadMPEntry event) {
    return MaterialPurchase(
      mpcode: event.mpcode,
      scode: event.scode,
      date: event.date,
      billno: event.billno,
      mcode: event.mcode,
      quantity: event.quantity,
      unitprice: event.unitprice,
      price: event.price,
      remarks: event.remarks,
    );
  }

  MPState _success(ResponseResult result) {
    return MPSuccess(result.status, result.message);
  }

  MPState _loading() {
    return MPLoading(true, "Uploading...");
  }

  MPState _errorAndClear(ResponseResult result) {
    return MPErrorAndClear(result.status, result.message);
  }

  MPState _error(ResponseResult result) {
    return MPError(result.status, result.message);
  }

  MPState _nullValueError() {
    return MPError(false, 'please fill required fields');
  }
}
