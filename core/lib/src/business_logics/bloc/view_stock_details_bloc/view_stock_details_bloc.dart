import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/src/business_logics/models/stock_details.dart';
import 'package:core/src/services/product_service.dart';
import 'package:core/src/services/stock_details_service.dart';
import 'package:equatable/equatable.dart';

part 'view_stock_details_event.dart';

part 'view_stock_details_state.dart';

class ViewStockDetailsBloc
    extends Bloc<ViewStockDetailsEvent, ViewStockDetailsState> {
  ViewStockDetailsBloc() : super(ViewStockDetailsLoading());

  final StockService _stockService = serviceLocator<StockService>();
  final ProductService _productService = serviceLocator<ProductService>();

  StockDetails _stockDetails;
  Products _products;
  List<StockDetail> _filteredStocks;

  String _query = "";

  @override
  Stream<ViewStockDetailsState> mapEventToState(
    ViewStockDetailsEvent event,
  ) async* {
    if (event is FetchStocksEvent) {
      yield* _mapFetchStocksToState();
    }
    if (event is FetchStocksEventByPName) {
      yield* _mapSearchAndFetchStocksToState(event.pname);
    }
  }

  Stream<ViewStockDetailsState> _mapFetchStocksToState() async* {
    try {
      yield ViewStockDetailsLoading();
      await loadData();

      _filteredStocks = _stockDetails.stocks.toList();
      // _sortAscendingByPName();

      yield _eventResult();
    } catch (e) {
      yield ViewStockDetailsError(e.toString());
    }
  }

  Stream<ViewStockDetailsState> _mapSearchAndFetchStocksToState(
      String pname) async* {
    try {
      if (_products == null) {
        await loadData();
      }
      _query = pname;
      if (_query != null) {
        print(_query);
        _extractResult();
        // if (sortByPName == sorting.ascending) {
        //   _sortAscendingByPName();
        // } else {
        //   _sortDescendingByPName();
        // }

        yield ViewStockDetailsLoaded(_filteredStocks);
      }
    } catch (e) {
      print(e.toString());

      yield ViewStockDetailsError(e.toString());
    }
  }

  Future<void> loadData() async {
    if (_products == null) {
      _products = await _productService.getAllProducts();
    }
    _stockDetails = await _stockService.getAllStocks();
  }

  void _extractResult() {
    if (_query != "") {
      String pcode = _products.products
          .where((product) =>
              product.pname.toLowerCase().contains(_query.toLowerCase()))
          .first
          .pcode;

      _filteredStocks = _stockDetails.stocks
          .where((stock) => stock.pcode.contains(pcode))
          .toList();
    }
  }

  ViewStockDetailsState _eventResult() {
    print("adsfasdf");

    if (_filteredStocks.length > 0) {
      return ViewStockDetailsLoaded(_filteredStocks);
    } else {
      return ViewStockDetailsError("no data found");
    }
  }
}
