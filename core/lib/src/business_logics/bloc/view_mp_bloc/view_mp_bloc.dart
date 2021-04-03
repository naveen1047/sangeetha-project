import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/src/services/material_purchase_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:core/src/business_logics/util/util.dart';

part 'view_mp_event.dart';
part 'view_mp_state.dart';

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
  var sortByDate = sorting.ascending;
  var sortBySName = sorting.ascending;
  var sortByMName = sorting.ascending;
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
    if (event is SearchAndFetchMPEvent) {
      yield* _mapSearchAndFetchMPToState(event.billNo);
    }
    if (event is SortMPBySName) {
      yield* _mapSortMPBySNameToState();
    }
    if (event is SortMPByDate) {
      yield* _mapSortMPBySNameToState();
    }
    if (event is SortMPByMName) {
      yield* _mapSortMPByMNameToState();
    }
    if (event is SortMPByBillNo) {
      yield* _mapSortMPByBillNoToState();
    }
    // if (event is SortMPByMaterial) {
    //   yield* _mapSortMPByMaterialToState();
    // }
    if (event is SortMPByUnit) {
      yield* _mapSortMPByUnitPriceToState();
    }
    if (event is SortMPByQuantity) {
      yield* _mapSortMPByQuantityToState();
    }
    if (event is SortMPByTotal) {
      yield* _mapSortMPByTotalToState();
    }
  }

  Stream<ViewMPState> _mapSearchAndFetchMPToState(String billNo) async* {
    try {
      _query = billNo;
      if (_query != null) {
        print(_query);
        _extractResult();
        // if (sortByName == sorting.ascending) {
        //   _sortAscendingByMName();
        // } else {
        //   _sortDescendingByMName();
        // }
        print(_filteredMP.toString());

        yield ViewMPLoadedState(_filteredMP);
      }
    } catch (e) {
      yield ViewMPErrorState(e.toString());
    }
  }

  Stream<ViewMPState> _mapFetchMPToState(
      ViewMPEvent event, String mpname) async* {
    try {
      yield ViewMPLoadingState();

      print("*********");
      _mp = await _viewMPService.getAllMaterialPurchases();
      print(_mp.materialPurchases.first.mpcode);
      print("*********");

      _filteredMP = _mp.materialPurchases;
      // _sortAscendingByMName();
      yield ViewMPLoadedState(_mp.materialPurchases);
      // yield _eventResult();
    } catch (e) {
      yield ViewMPErrorState(e.toString());
    }
  }

  Stream<ViewMPState> _mapSortMPBySNameToState() async* {
    try {
      _filteredMP = _mp.materialPurchases.toList();
      if (sortBySName != sorting.ascending) {
        _extractResult();
        _sortAscendingBySName();
        sortBySName = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingBySName();
        sortBySName = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ViewMPErrorState(e.toString());
    }
  }

  // Stream<ViewMPState> _mapSortMPByDateToState() async* {
  //   try {
  //     _filteredMP = _mp.materialPurchases.toList();
  //     if (sortByDate != sorting.ascending) {
  //       _extractResult();
  //       _sortAscendingByDate();
  //       sortByDate = sorting.ascending;
  //     } else {
  //       _extractResult();
  //       _sortDescendingByDate();
  //       sortByDate = sorting.descending;
  //     }
  //     yield _eventResult();
  //   } catch (e) {
  //     yield ViewMPErrorState(e.toString());
  //   }
  // }

  Stream<ViewMPState> _mapSortMPByMNameToState() async* {
    try {
      _filteredMP = _mp.materialPurchases.toList();
      if (sortByMName != sorting.ascending) {
        _extractResult();
        _sortAscendingByMName();
        sortByMName = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByMName();
        sortByMName = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ViewMPErrorState(e.toString());
    }
  }

  Stream<ViewMPState> _mapSortMPByBillNoToState() async* {
    try {
      _filteredMP = _mp.materialPurchases.toList();
      if (sortByBillNo != sorting.ascending) {
        _extractResult();
        _sortAscendingByMBillNo();
        sortByBillNo = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByMBillNo();
        sortByBillNo = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ViewMPErrorState(e.toString());
    }
  }

  Stream<ViewMPState> _mapSortMPByTotalToState() async* {
    try {
      _filteredMP = _mp.materialPurchases.toList();
      if (sortByTotal != sorting.ascending) {
        _extractResult();
        _sortAscendingByTotal();
        sortByTotal = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByTotal();
        sortByTotal = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ViewMPErrorState(e.toString());
    }
  }

  Stream<ViewMPState> _mapSortMPByUnitPriceToState() async* {
    try {
      _filteredMP = _mp.materialPurchases.toList();
      // TODO: error here change it to sortByUnitPrice
      if (sortByTotal != sorting.ascending) {
        _extractResult();
        _sortAscendingByUnitPrice();
        sortByTotal = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByUnitPrice();
        sortByTotal = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ViewMPErrorState(e.toString());
    }
  }

  Stream<ViewMPState> _mapSortMPByQuantityToState() async* {
    try {
      _filteredMP = _mp.materialPurchases.toList();
      if (sortByQuantity != sorting.ascending) {
        _extractResult();
        _sortAscendingByQuantity();
        sortByQuantity = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByQuantity();
        sortByQuantity = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ViewMPErrorState(e.toString());
    }
  }

  void _sortAscendingBySName() {
    _filteredMP
        .sort((a, b) => a.sname.toLowerCase().compareTo(b.sname.toLowerCase()));
  }

  void _sortDescendingBySName() {
    _filteredMP
        .sort((a, b) => b.sname.toLowerCase().compareTo(a.sname.toLowerCase()));
  }

  // void _sortAscendingByDate() {
  //   _filteredMP
  //       .sort((a, b) => a.date.toLowerCase().compareTo(b.date.toLowerCase()));
  // }
  //
  // void _sortDescendingByDate() {
  //   _filteredMP
  //       .sort((a, b) => b.date.toLowerCase().compareTo(a.date.toLowerCase()));
  // }

  void _sortAscendingByMName() {
    _filteredMP
        .sort((a, b) => a.mname.toLowerCase().compareTo(b.mname.toLowerCase()));
  }

  void _sortDescendingByMName() {
    _filteredMP
        .sort((a, b) => b.mname.toLowerCase().compareTo(a.mname.toLowerCase()));
  }

  void _sortAscendingByMBillNo() {
    _filteredMP.sort(
        (a, b) => a.billno.toLowerCase().compareTo(b.billno.toLowerCase()));
  }

  void _sortDescendingByMBillNo() {
    _filteredMP.sort(
        (a, b) => b.billno.toLowerCase().compareTo(a.billno.toLowerCase()));
  }

  void _sortAscendingByTotal() {
    _filteredMP
        .sort((a, b) => double.parse(a.price).compareTo(double.parse(b.price)));
  }

  void _sortDescendingByTotal() {
    _filteredMP
        .sort((a, b) => double.parse(b.price).compareTo(double.parse(a.price)));
  }

  void _sortAscendingByUnitPrice() {
    _filteredMP.sort((a, b) =>
        double.parse(a.unitprice).compareTo(double.parse(b.unitprice)));
  }

  void _sortDescendingByUnitPrice() {
    _filteredMP.sort((a, b) =>
        double.parse(b.unitprice).compareTo(double.parse(a.unitprice)));
  }

  void _sortAscendingByQuantity() {
    _filteredMP.sort(
        (a, b) => double.parse(a.quantity).compareTo(double.parse(b.quantity)));
  }

  void _sortDescendingByQuantity() {
    _filteredMP.sort(
        (a, b) => double.parse(b.quantity).compareTo(double.parse(a.quantity)));
  }

  void _extractResult() {
    _filteredMP = _mp.materialPurchases
        .where((element) =>
            element.billno.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  ViewMPState _eventResult() {
    if (_filteredMP.length > 0) {
      return ViewMPLoadedState(_filteredMP);
    } else {
      return ViewMPErrorState("no data found");
    }
  }
}
