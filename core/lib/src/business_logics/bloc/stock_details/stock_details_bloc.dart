import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/stock_details.dart';
import 'package:core/src/services/stock_details_service.dart';
import 'package:equatable/equatable.dart';

import '../../../../core.dart';

part 'stock_details_event.dart';
part 'stock_details_state.dart';

class StockDetailsBloc extends Bloc<StockDetailsEvent, StockDetailsState> {
  StockDetailsBloc() : super(StockDetailsIdle());

  final StockService _stockService = serviceLocator<StockService>();

  @override
  Stream<StockDetailsState> mapEventToState(
    StockDetailsEvent event,
  ) async* {
    if (event is EditStock) {
      yield* _mapEditStockToState(event);
    }
  }

  Stream<StockDetailsState> _mapEditStockToState(
      StockDetailsEvent event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      ResponseResult result =
          await _stockService.editStockByCode(_stockDetail(event));
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

  StockDetail _stockDetail(var event) {
    return StockDetail(
      pcode: event.pcode,
      cstock: event.cstock,
      rstock: event.rstock,
      tstock: event.tstock,
    );
  }

  bool _isEventAttributeIsNotNull(var event) {
    if (event.tstock != '' && event.rstock != '' && event.cstock != '') {
      return true;
    } else {
      return false;
    }
  }

  StockDetailsState _loading() {
    return StockDetailsLoading(true, "Uploading..");
  }

  StockDetailsState _success(ResponseResult result) {
    return StockDetailsSuccess(result.status, result.message);
  }

  StockDetailsState _errorAndClear(ResponseResult result) {
    return StockDetailsErrorAndClear(result.status, result.message);
  }

  StockDetailsState _nullValueError() {
    return StockDetailsError(false, 'please fill required fields');
  }
}
