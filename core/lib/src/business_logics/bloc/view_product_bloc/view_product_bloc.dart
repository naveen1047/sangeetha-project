import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/product.dart';
import 'package:core/src/services/product_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:core/src/business_logics/util/util.dart';

part 'view_product_event.dart';
part 'view_product_state.dart';

// TODO: return state with value (sortBy, sorting)
enum sortProductBy { name, unit, price }

// bloc
class ViewProductBloc extends Bloc<ViewProductEvent, ViewProductState> {
  ViewProductBloc() : super(ProductLoadingState());

  final ProductService _viewProductService = serviceLocator<ProductService>();

  Products _products;
  List<Product> _filteredProduct;

  // search key
  String _query = '';

  // sorting
  var sortByName = sorting.ascending;
  var sortByUnit = sorting.ascending;
  var sortByPrice = sorting.ascending;

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
    // if (event is SortProductByName) {
    //   yield* _mapSortProductByNameToState();
    // }
    // if (event is SortProductByUnit) {
    //   yield* _mapSortProductByUnitToState();
    // }
    // if (event is SortProductByPrice) {
    //   yield* _mapSortProductByPriceToState();
    // }
  }

  // TODO: ugly state do sink and stream
  Stream<ViewProductState> _mapSearchAndFetchProductToState(
      String pname) async* {
    try {
      _query = pname;
      if (_query != null) {
        print(_query);
        _extractResult();
        if (sortByName == sorting.ascending) {
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

  /// TODO: sort products by ( price) and yield result
  // Stream<ViewProductState> _mapSortProductByNameToState() async* {
  //   try {
  //     _filteredProduct = _products.products.toList();
  //     if (sortByName != sorting.ascending) {
  //       _extractResult();
  //       _sortAscendingByPName();
  //       sortByName = sorting.ascending;
  //     } else {
  //       _extractResult();
  //       _sortDescendingByPName();
  //       sortByName = sorting.descending;
  //     }
  //     yield _eventResult();
  //   } catch (e) {
  //     yield ProductErrorState(e.toString());
  //   }
  // }

  // Stream<ViewProductState> _mapSortProductByUnitToState() async* {
  //   try {
  //     _filteredProduct = _products.products.toList();
  //     if (sortByUnit != sorting.ascending) {
  //       _extractResult();
  //       _sortAscendingByMUnit();
  //       sortByUnit = sorting.ascending;
  //     } else {
  //       _extractResult();
  //       _sortDescendingByMUnit();
  //       sortByUnit = sorting.descending;
  //     }
  //     yield _eventResult();
  //   } catch (e) {
  //     yield ProductErrorState(e.toString());
  //   }
  // }

  // Stream<ViewProductState> _mapSortProductByPriceToState() async* {
  //   try {
  //     _filteredProduct = _products.products.toList();
  //     if (sortByPrice != sorting.ascending) {
  //       _extractResult();
  //       _sortAscendingByMPrice();
  //       sortByPrice = sorting.ascending;
  //     } else {
  //       _extractResult();
  //       _sortDescendingByMPrice();
  //       sortByPrice = sorting.descending;
  //     }
  //     yield _eventResult();
  //   } catch (e) {
  //     yield ProductErrorState(e.toString());
  //   }
  // }

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

  // void _sortAscendingByMUnit() {
  //   _filteredProduct
  //       .sort((a, b) => double.parse(a.munit).compareTo(double.parse(b.munit)));
  // }
  //
  // void _sortDescendingByMUnit() {
  //   _filteredProduct
  //       .sort((a, b) => double.parse(b.munit).compareTo(double.parse(a.munit)));
  // }
  //
  // void _sortAscendingByMPrice() {
  //   _filteredProduct.sort((a, b) =>
  //       double.parse(a.mpriceperunit).compareTo(double.parse(b.ppriceperunit)));
  // }
  //
  // void _sortDescendingByMPrice() {
  //   _filteredProduct.sort((a, b) =>
  //       double.parse(b.mpriceperunit).compareTo(double.parse(a.mpriceperunit)));
  void _extractResult() {
    _filteredProduct = _products.products
        .where((element) =>
            element.pname.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }
}
// }
