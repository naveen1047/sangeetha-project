import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/product.dart';
import 'package:core/src/services/product_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:core/src/business_logics/util/util.dart';

part 'view_product_event.dart';
part 'view_product_state.dart';

class ViewProductBloc extends Bloc<ViewProductEvent, ViewProductState> {
  ViewProductBloc() : super(ProductLoadingState());

  final ProductService _viewProductService = serviceLocator<ProductService>();

  Products _products;
  List<Product> _filteredProduct;

  // search key
  String _query = '';

  // sorting
  var sortByPName = sorting.ascending;
  var sortBySalaryPerStroke = sorting.ascending;
  var sortByNosProducedPerStroke = sorting.ascending;
  var sortBySellingUnit = sorting.ascending;
  var sortByPricePerSellingUnit = sorting.ascending;
  var sortByNosPerSellingUnit = sorting.ascending;

  @override
  Future<void> close() {
    _products = null;
    _filteredProduct.clear();
    return super.close();
  }

  @override
  Stream<ViewProductState> mapEventToState(ViewProductEvent event) async* {
    if (event is FetchProductEvent) {
      yield* _mapFetchProductToState(event, event.pname);
    }
    if (event is SearchAndFetchProductEvent) {
      yield* _mapSearchAndFetchProductToState(event.pname);
    }
    if (event is SortProductByName) {
      yield* _mapSortProductByNameToState();
    }
    if (event is SortProductBySalaryPerStroke) {
      yield* _mapSortProductBySalaryPerStrokeToState();
    }
    if (event is SortProductByNosProducedPerStroke) {
      yield* _mapSortProductByNosProducedPerStrokeToState();
    }
    if (event is SortProductBySellingUnit) {
      yield* _mapSortProductBySellingUnit();
    }
    if (event is SortProductByPricePerSellingUnit) {
      yield* _mapSortProductByPricePerSellingUnit();
    }
    if (event is SortProductByNosPerSellingUnit) {
      yield* _mapSortProductByNosPerSellingUnit();
    }
  }

  // TODO: ugly state do sink and stream
  Stream<ViewProductState> _mapSearchAndFetchProductToState(
      String pname) async* {
    try {
      _query = pname;
      if (_query != null) {
        print(_query);
        _extractResult();
        if (sortByPName == sorting.ascending) {
          _sortAscendingByPName();
        } else {
          _sortDescendingByPName();
        }
        print(_filteredProduct.toString());

        yield ProductLoadedState(_filteredProduct);
      }
    } catch (e) {
      yield ProductErrorState(e.toString());
    }
  }

  Stream<ViewProductState> _mapFetchProductToState(
      ViewProductEvent event, String pname) async* {
    try {
      yield ProductLoadingState();

      _products = await _viewProductService.getAllProducts();

      _filteredProduct = _products.products.toList();
      _sortAscendingByPName();

      yield _eventResult();
    } catch (e) {
      yield ProductErrorState(e.toString());
    }
  }

  Stream<ViewProductState> _mapSortProductByNameToState() async* {
    try {
      _filteredProduct = _products.products.toList();
      if (sortByPName != sorting.ascending) {
        _extractResult();
        _sortAscendingByPName();
        sortByPName = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByPName();
        sortByPName = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ProductErrorState(e.toString());
    }
  }

  Stream<ViewProductState> _mapSortProductBySalaryPerStrokeToState() async* {
    try {
      _filteredProduct = _products.products.toList();
      if (sortBySalaryPerStroke != sorting.ascending) {
        _extractResult();
        _sortAscendingBySalaryPerStroke();
        sortBySalaryPerStroke = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingBySalaryPerStroke();
        sortBySalaryPerStroke = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ProductErrorState(e.toString());
    }
  }

  Stream<ViewProductState>
      _mapSortProductByNosProducedPerStrokeToState() async* {
    try {
      _filteredProduct = _products.products.toList();
      if (sortByNosProducedPerStroke != sorting.ascending) {
        _extractResult();
        _sortAscendingByNosProducedPerStroke();
        sortByNosProducedPerStroke = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByNosProducedPerStroke();
        sortByNosProducedPerStroke = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ProductErrorState(e.toString());
    }
  }

  Stream<ViewProductState> _mapSortProductBySellingUnit() async* {
    try {
      _filteredProduct = _products.products.toList();
      if (sortBySellingUnit != sorting.ascending) {
        _extractResult();
        _sortAscendingBySellingUnit();
        sortBySellingUnit = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingBySellingUnit();
        sortBySellingUnit = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ProductErrorState(e.toString());
    }
  }

  Stream<ViewProductState> _mapSortProductByPricePerSellingUnit() async* {
    try {
      _filteredProduct = _products.products.toList();
      if (sortByPricePerSellingUnit != sorting.ascending) {
        _extractResult();
        _sortAscendingByPricePerSellingUnit();
        sortByPricePerSellingUnit = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByPricePerSellingUnit();
        sortByPricePerSellingUnit = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ProductErrorState(e.toString());
    }
  }

  Stream<ViewProductState> _mapSortProductByNosPerSellingUnit() async* {
    try {
      _filteredProduct = _products.products.toList();
      if (sortByNosPerSellingUnit != sorting.ascending) {
        _extractResult();
        _sortAscendingByNosPerSellingUnit();
        sortByNosPerSellingUnit = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByNosPerSellingUnit();
        sortByNosPerSellingUnit = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ProductErrorState(e.toString());
    }
  }

  ViewProductState _eventResult() {
    if (_filteredProduct.length > 0) {
      return ProductLoadedState(_filteredProduct);
    } else {
      return ProductErrorState("no data found");
    }
  }

  void _sortAscendingByPName() {
    _filteredProduct
        .sort((a, b) => a.pname.toLowerCase().compareTo(b.pname.toLowerCase()));
  }

  void _sortDescendingByPName() {
    _filteredProduct
        .sort((a, b) => b.pname.toLowerCase().compareTo(a.pname.toLowerCase()));
  }

  void _sortAscendingBySalaryPerStroke() {
    _filteredProduct.sort(
        (a, b) => double.parse(a.salaryps).compareTo(double.parse(b.salaryps)));
  }

  void _sortDescendingBySalaryPerStroke() {
    _filteredProduct.sort(
        (a, b) => double.parse(b.salaryps).compareTo(double.parse(a.salaryps)));
  }

  void _sortAscendingByNosProducedPerStroke() {
    _filteredProduct
        .sort((a, b) => double.parse(a.nosps).compareTo(double.parse(b.nosps)));
  }

  void _sortDescendingByNosProducedPerStroke() {
    _filteredProduct
        .sort((a, b) => double.parse(b.nosps).compareTo(double.parse(a.nosps)));
  }

  void _sortAscendingBySellingUnit() {
    _filteredProduct
        .sort((a, b) => a.sunit.toLowerCase().compareTo(b.sunit.toLowerCase()));
  }

  void _sortDescendingBySellingUnit() {
    _filteredProduct
        .sort((a, b) => double.parse(b.nosps).compareTo(double.parse(a.nosps)));
  }

  void _sortAscendingByPricePerSellingUnit() {
    _filteredProduct.sort((a, b) =>
        double.parse(a.pricepersunit).compareTo(double.parse(b.pricepersunit)));
  }

  void _sortDescendingByPricePerSellingUnit() {
    _filteredProduct.sort((a, b) =>
        double.parse(b.pricepersunit).compareTo(double.parse(a.pricepersunit)));
  }

  void _sortAscendingByNosPerSellingUnit() {
    _filteredProduct.sort((a, b) =>
        double.parse(a.nospsunit).compareTo(double.parse(b.nospsunit)));
  }

  void _sortDescendingByNosPerSellingUnit() {
    _filteredProduct.sort((a, b) =>
        double.parse(b.nospsunit).compareTo(double.parse(a.nospsunit)));
  }

  void _extractResult() {
    _filteredProduct = _products.products
        .where((element) =>
            element.pname.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }
}
