import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/src/business_logics/models/stock_details.dart';
import 'package:core/src/services/product_service.dart';
import 'package:core/src/services/stock_details_service.dart';
import 'package:equatable/equatable.dart';
import 'package:core/src/business_logics/util/util.dart';

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

  // sorting
  var sortByPName = sorting.ascending;
  var sortByLStock = sorting.ascending;
  var sortByRStock = sorting.ascending;
  var sortByTStock = sorting.ascending;

  // var sortBySalaryPerStroke = sorting.ascending;
  // var sortByNosProducedPerStroke = sorting.ascending;
  // var sortBySellingUnit = sorting.ascending;
  // var sortByPricePerSellingUnit = sorting.ascending;
  // var sortByNosPerSellingUnit = sorting.ascending;

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
    if (event is SortStockByPName) {
      yield* _mapSortStockByPNameToState();
    }
    if (event is SortStockByLStock) {
      yield* _mapSortStockByLStockToState();
    }
    if (event is SortStockByRStock) {
      yield* _mapSortStockByRStockToState();
    }
    if (event is SortStockByTStock) {
      yield* _mapSortStockByTStockToState();
    }
  }

  Stream<ViewStockDetailsState> _mapFetchStocksToState() async* {
    try {
      yield ViewStockDetailsLoading();
      await loadData();

      _filteredStocks = _stockDetails.stocks.toList();
      _sortAscendingByPName();

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
        if (sortByPName == sorting.ascending) {
          _sortAscendingByPName();
        } else {
          _sortDescendingByPName();
        }

        yield ViewStockDetailsLoaded(_filteredStocks);
      }
    } catch (e) {
      print(e.toString());

      yield ViewStockDetailsError(e.toString());
    }
  }

  Stream<ViewStockDetailsState> _mapSortStockByPNameToState() async* {
    try {
      await loadData();
      _filteredStocks = _stockDetails.stocks.toList();
      if (sortByPName != sorting.ascending) {
        _extractResult();
        _sortAscendingByPName();
        sortByPName = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByPName();
        sortByPName = sorting.descending;
      }
      print("Print this when sorted ....");
      _filteredStocks.forEach((stock) {
        print(_products.products
            .where((prd) => prd.pcode.contains(stock.pcode))
            .first
            .pname);
      });
      yield _eventResult();
    } catch (e) {
      yield ViewStockDetailsError(e.toString());
    }
  }

  Stream<ViewStockDetailsState> _mapSortStockByLStockToState() async* {
    try {
      await loadData();
      _filteredStocks = _stockDetails.stocks.toList();
      if (sortByLStock != sorting.ascending) {
        _extractResult();
        _sortAscendingByLStock();
        sortByLStock = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByLStock();
        sortByLStock = sorting.descending;
      }
      print("Print this when sorted ....");
      _filteredStocks.forEach((stock) {
        print(_products.products
            .where((prd) => prd.pcode.contains(stock.pcode))
            .first
            .pname);
      });
      yield _eventResult();
    } catch (e) {
      yield ViewStockDetailsError(e.toString());
    }
  }

  Stream<ViewStockDetailsState> _mapSortStockByRStockToState() async* {
    try {
      await loadData();
      _filteredStocks = _stockDetails.stocks.toList();
      if (sortByRStock != sorting.ascending) {
        _extractResult();
        _sortAscendingByRStock();
        sortByRStock = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByRStock();
        sortByRStock = sorting.descending;
      }
      print("Print this when sorted ....");
      _filteredStocks.forEach((stock) {
        print(_products.products
            .where((prd) => prd.pcode.contains(stock.pcode))
            .first
            .pname);
      });
      yield _eventResult();
    } catch (e) {
      yield ViewStockDetailsError(e.toString());
    }
  }

  Stream<ViewStockDetailsState> _mapSortStockByTStockToState() async* {
    try {
      await loadData();
      _filteredStocks = _stockDetails.stocks.toList();
      if (sortByTStock != sorting.ascending) {
        _extractResult();
        _sortAscendingByTStock();
        sortByTStock = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByTStock();
        sortByTStock = sorting.descending;
      }
      print("Print this when sorted ....");
      _filteredStocks.forEach((stock) {
        print(_products.products
            .where((prd) => prd.pcode.contains(stock.pcode))
            .first
            .pname);
      });
      yield _eventResult();
    } catch (e) {
      yield ViewStockDetailsError(e.toString());
    }
  }

  void _sortAscendingByPName() {
    _filteredStocks.sort((a, b) => _products.products
        .where((prd) => prd.pcode.contains(a.pcode))
        .first
        .pname
        .toLowerCase()
        .compareTo(_products.products
            .where((prd) => prd.pcode.contains(b.pcode))
            .first
            .pname
            .toLowerCase()));
  }

  void _sortDescendingByPName() {
    _filteredStocks.sort((b, a) => _products.products
        .where((prd) => prd.pcode.contains(a.pcode))
        .first
        .pname
        .toLowerCase()
        .compareTo(_products.products
            .where((prd) => prd.pcode.contains(b.pcode))
            .first
            .pname
            .toLowerCase()));
  }

  void _sortAscendingByLStock() {
    _filteredStocks.sort(
        (a, b) => a.cstock.toLowerCase().compareTo(b.cstock.toLowerCase()));
  }

  void _sortDescendingByLStock() {
    _filteredStocks.sort(
        (b, a) => a.cstock.toLowerCase().compareTo(b.cstock.toLowerCase()));
  }

  void _sortAscendingByRStock() {
    _filteredStocks.sort(
        (a, b) => a.rstock.toLowerCase().compareTo(b.rstock.toLowerCase()));
  }

  void _sortDescendingByRStock() {
    _filteredStocks.sort(
        (b, a) => a.rstock.toLowerCase().compareTo(b.rstock.toLowerCase()));
  }

  void _sortAscendingByTStock() {
    _filteredStocks.sort(
        (a, b) => a.tstock.toLowerCase().compareTo(b.tstock.toLowerCase()));
  }

  void _sortDescendingByTStock() {
    _filteredStocks.sort(
        (b, a) => a.tstock.toLowerCase().compareTo(b.tstock.toLowerCase()));
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
