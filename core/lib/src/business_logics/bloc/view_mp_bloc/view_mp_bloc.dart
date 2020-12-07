import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/src/business_logics/models/material.dart';
import 'package:core/src/services/material_purchase_service.dart';
import 'package:core/src/services/material_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:core/src/business_logics/util/util.dart';

part 'view_mp_event.dart';
part 'view_mp_state.dart';

// TODO: return state with value (sortBy, sorting)
enum sortMPBy { name, unit, price }

// bloc
class ViewMPBloc extends Bloc<ViewMPEvent, ViewMPState> {
  ViewMPBloc() : super(ViewMPLoadingState());

  final MaterialPurchaseService _viewMPService =
      serviceLocator<MaterialPurchaseService>();

  MaterialPurchases _mp;
  List<MaterialPurchase> _filteredMP;

  // search key
  String _query = '';

  // sorting
  var sortByName = sorting.ascending;
  var sortByBillNo = sorting.ascending;
  var sortByMaterial = sorting.ascending;
  var sortByUnit = sorting.ascending;
  var sortByQuantity = sorting.ascending;
  var sortByTotal = sorting.ascending;

  @override
  Future<void> close() {
    _mp = null;
    _filteredMP.clear();
    return super.close();
  }

  @override
  Stream<ViewMPState> mapEventToState(ViewMPEvent event) async* {
    if (event is FetchMPEvent) {
      yield* _mapFetchMPToState(event, event.mname);
    }
    // if (event is SearchAndFetchMPEvent) {
    //   yield* _mapSearchAndFetchMPToState(event.mname);
    // }
    // if (event is SortMPByName) {
    //   yield* _mapSortMPByNameToState();
    // }
    // if (event is SortMPByBillNo) {
    //   yield* _mapSortMPByBillNoToState();
    // }
    // if (event is SortMPByMaterial) {
    //   yield* _mapSortMPByMaterialToState();
    // }
    // if (event is sortByUnit) {
    //   yield* _mapSortByUnitToState();
    // }
    // if (event is sortByQuantity) {
    //   yield* _mapSortByQuantityToState();
    // }
    // if (event is sortByTotal) {
    //   yield* _mapSortByTotalToState();
    // }
  }

  // TODO: ugly state do sink and stream
  // Stream<ViewMPState> _mapSearchAndFetchMPToState(String mpname) async* {
  //   try {
  //     _query = mpname;
  //     if (_query != null) {
  //       print(_query);
  //       _extractResult();
  //       if (sortByName == sorting.ascending) {
  //         _sortAscendingByMName();
  //       } else {
  //         _sortDescendingByMName();
  //       }
  //       print(_filteredMP.toString());
  //
  //       yield  ViewMPLoadedState(_filteredMP);
  //     }
  //   } catch (e) {
  //     yield  ViewMPErrorState(e.toString());
  //   }
  // }

  Stream<ViewMPState> _mapFetchMPToState(
      ViewMPEvent event, String mpname) async* {
    try {
      yield ViewMPLoadingState();

      _mp = await _viewMPService.getAllMaterialPurchases();
      print(_mp.materialPurchases.first.mpcode);

      _filteredMP = _mp.materialPurchases;
      // _sortAscendingByMName();
      yield ViewMPLoadedState(_mp.materialPurchases);
      // yield _eventResult();
    } catch (e) {
      yield ViewMPErrorState(e.toString());
    }
  }

  /// TODO: sort materials by ( price) and yield result
  // Stream<ViewMPState> _mapSortMPByNameToState() async* {
  //   try {
  //     _filteredMP = _mp.materials.toList();
  //     if (sortByName != sorting.ascending) {
  //       _extractResult();
  //       _sortAscendingByMName();
  //       sortByName = sorting.ascending;
  //     } else {
  //       _extractResult();
  //       _sortDescendingByMName();
  //       sortByName = sorting.descending;
  //     }
  //     yield _eventResult();
  //   } catch (e) {
  //     yield  ViewMPErrorState(e.toString());
  //   }
  // }
  //
  // Stream<ViewMPState> _mapSortMPByBillNoToState() async* {
  //   try {
  //     _filteredMP = _mp.materials.toList();
  //     if (sortByBillNo != sorting.ascending) {
  //       _extractResult();
  //       _sortAscendingByMBillNo();
  //       sortByBillNo = sorting.ascending;
  //     } else {
  //       _extractResult();
  //       _sortDescendingByMBillNo();
  //       sortByBillNo = sorting.descending;
  //     }
  //     yield _eventResult();
  //   } catch (e) {
  //     yield  ViewMPErrorState(e.toString());
  //   }
  // }
  //
  // Stream<ViewMPState> _mapSortMPByPriceToState() async* {
  //   try {
  //     _filteredMP = _mp.materials.toList();
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
  //     yield  ViewMPErrorState(e.toString());
  //   }
  // }

  ViewMPState _eventResult() {
    if (_filteredMP.length > 0) {
      return ViewMPLoadedState(_filteredMP);
    } else {
      return ViewMPErrorState("no data found");
    }
  }

  // void _sortAscendingByMName() {
  //   _filteredMP
  //       .sort((a, b) => a.mname.toLowerCase().compareTo(b.mname.toLowerCase()));
  // }
  //
  // void _sortDescendingByMName() {
  //   _filteredMP
  //       .sort((a, b) => b.mname.toLowerCase().compareTo(a.mname.toLowerCase()));
  // }
  //
  // void _sortAscendingByMBillNo() {
  //   _filteredMP
  //       .sort((a, b) => double.parse(a.munit).compareTo(double.parse(b.munit)));
  // }
  //
  // void _sortDescendingByMBillNo() {
  //   _filteredMP
  //       .sort((a, b) => double.parse(b.munit).compareTo(double.parse(a.munit)));
  // }
  //
  // void _sortAscendingByMPrice() {
  //   _filteredMP.sort((a, b) =>
  //       double.parse(a.mpriceperunit).compareTo(double.parse(b.mpriceperunit)));
  // }
  //
  // void _sortDescendingByMPrice() {
  //   _filteredMP.sort((a, b) =>
  //       double.parse(b.mpriceperunit).compareTo(double.parse(a.mpriceperunit)));
  // }
  //
  // void _extractResult() {
  //   _filteredMP = _mp.materials
  //       .where((element) =>
  //           element.mname.toLowerCase().contains(_query.toLowerCase()))
  //       .toList();
  // }
}
