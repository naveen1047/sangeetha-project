import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/src/services/employee_service.dart';
import 'package:core/src/services/product_service.dart';
import 'package:core/src/services/production_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:core/src/business_logics/util/util.dart';

part 'view_production_event.dart';

part 'view_production_state.dart';

// bloc
class ViewProductionBloc
    extends Bloc<ViewProductionEvent, ViewProductionState> {
  ViewProductionBloc() : super(ViewProductionLoadingState());

  final ProductionService _viewProductionService =
      serviceLocator<ProductionService>();

  Productions _pd;
  List<Production> _filteredProduction;

  // search key
  String _query = '';

  // sorting
  var sortProductionByDate = sorting.ascending;
  var sortProductionByEName = sorting.ascending;
  var sortProductionByPName = sorting.ascending;
  var sortProductionBySalaryPS = sorting.ascending;
  var sortProductionByNoOfS = sorting.ascending;
  var sortProductionBySalary = sorting.ascending;
  var sortByTotal = sorting.ascending;

  @override
  Future<void> close() {
    _pd = null;
    _filteredProduction?.clear();
    return super.close();
  }

  @override
  Stream<ViewProductionState> mapEventToState(
      ViewProductionEvent event) async* {
    if (event is FetchProductionEvent) {
      yield* _mapFetchProductionToState();
    }
    if (event is SearchAndFetchProductionEvent) {
      yield* _mapSearchAndFetchProductionToState(event.ename);
    }
    if (event is SortProductionByEName) {
      yield* _mapSortProductionByENameToState();
    }
    if (event is SortProductionByDate) {
      yield* _mapSortProductionByDateToState();
    }
    if (event is SortProductionByPName) {
      yield* _mapSortProductionByPNameToState();
    }
    // if (event is SortProductionByMaterial) {
    //   yield* _mapSortProductionByMaterialToState();
    // }
    if (event is SortProductionBySalaryPS) {
      yield* _mapSortProductionBySalaryPSToState();
    }
    if (event is SortProductionByNoOfS) {
      yield* _mapSortProductionByNoOfSToState();
    }
    if (event is SortProductionBySalary) {
      yield* _mapSortProductionBySalaryToState();
    }
    // if (event is SortProductionByTotal) {
    //   yield* _mapSortProductionByTotalToState();
    // }
  }

  Stream<ViewProductionState> _mapSearchAndFetchProductionToState(
      String teamName) async* {
    try {
      // yield ViewProductionLoadingState();
      _query = teamName;
      if (_query != null || _query != "") {
        print(_pd.toString());

        if (_pd == null) {
          _pd = await _viewProductionService.getAllProductions();
        }
        _extractResult();
        // if (sortProductionByEName == sorting.ascending) {
        //   _sortAscendingByEName();
        // } else {
        //   _sortDescendingByEName();
        // }
        print(_filteredProduction.toString());

        yield ViewProductionLoadedState(_filteredProduction);
      } else {
        _mapFetchProductionToState();
      }
    } catch (e) {
      yield ViewProductionErrorState(e.toString());
    }
  }

  Stream<ViewProductionState> _mapFetchProductionToState() async* {
    try {
      yield ViewProductionLoadingState();

      await loadProductions();

      // _sortAscendingByMName();
      yield ViewProductionLoadedState(_filteredProduction);
      // yield _eventResult();
    } catch (e) {
      print(e.toString());

      yield ViewProductionErrorState(e.toString());
    }
  }

  Stream<ViewProductionState> _mapSortProductionByENameToState() async* {
    try {
      _filteredProduction = _pd.productions.toList();

      if (sortProductionByEName != sorting.ascending) {
        _extractResult();
        _sortAscendingByEName();
        sortProductionByEName = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByEName();
        sortProductionByEName = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ViewProductionErrorState(e.toString());
    }
  }

  Stream<ViewProductionState> _mapSortProductionByDateToState() async* {
    try {
      await loadProductions();

      // _filteredProduction = _pd.productions.toList();
      print(_filteredProduction.length);

      if (sortProductionByDate != sorting.ascending) {
        print("asdfasfdasdf");

        _extractResult();
        _sortAscendingByDate();
        sortProductionByDate = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByDate();
        sortProductionByDate = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      print(e.toString());

      yield ViewProductionErrorState(e.toString());
    }
  }

  Stream<ViewProductionState> _mapSortProductionByPNameToState() async* {
    try {
      _filteredProduction = _pd.productions.toList();
      if (sortProductionByPName != sorting.ascending) {
        _extractResult();
        _sortAscendingByPName();
        sortProductionByPName = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByPName();
        sortProductionByPName = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ViewProductionErrorState(e.toString());
    }
  }

  Stream<ViewProductionState> _mapSortProductionBySalaryPSToState() async* {
    try {
      _filteredProduction = _pd.productions.toList();
      if (sortProductionBySalaryPS != sorting.ascending) {
        _extractResult();
        _sortAscendingBySalaryPSPrice();
        sortProductionBySalaryPS = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingBySalaryPSPrice();
        sortProductionBySalaryPS = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ViewProductionErrorState(e.toString());
    }
  }

  Stream<ViewProductionState> _mapSortProductionByNoOfSToState() async* {
    try {
      _filteredProduction = _pd.productions.toList();
      if (sortProductionByNoOfS != sorting.ascending) {
        _extractResult();
        _sortAscendingByNoOfS();
        sortProductionByNoOfS = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByNoOfS();
        sortProductionByNoOfS = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ViewProductionErrorState(e.toString());
    }
  }

  Stream<ViewProductionState> _mapSortProductionBySalaryToState() async* {
    try {
      _filteredProduction = _pd.productions.toList();
      if (sortProductionBySalary != sorting.ascending) {
        _extractResult();
        _sortAscendingSalary();
        sortProductionBySalary = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingBySalary();
        sortProductionBySalary = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield ViewProductionErrorState(e.toString());
    }
  }

  void _sortAscendingByEName() {
    _filteredProduction
        .sort((a, b) => a.ename.toLowerCase().compareTo(b.ename.toLowerCase()));
  }

  void _sortDescendingByEName() {
    _filteredProduction
        .sort((a, b) => b.ename.toLowerCase().compareTo(a.ename.toLowerCase()));
  }

  // TODO: nos is not sorting properly
  void _sortAscendingByNoOfS() {
    _filteredProduction.sort((a, b) => a.nos.compareTo(b.nos));
  }

  void _sortDescendingByNoOfS() {
    _filteredProduction.sort((a, b) => b.nos.compareTo(a.nos));
  }

  void _sortAscendingByDate() {
    _filteredProduction
        .sort((a, b) => a.date.toLowerCase().compareTo(b.date.toLowerCase()));
  }

  void _sortDescendingByDate() {
    _filteredProduction
        .sort((a, b) => b.date.toLowerCase().compareTo(a.date.toLowerCase()));
  }

  void _sortAscendingByPName() {
    _filteredProduction
        .sort((a, b) => a.pname.toLowerCase().compareTo(b.pname.toLowerCase()));
  }

  void _sortDescendingByPName() {
    _filteredProduction
        .sort((b, a) => a.pname.toLowerCase().compareTo(b.pname.toLowerCase()));
  }

  void _sortAscendingBySalaryPSPrice() {
    _filteredProduction
        .sort((a, b) => double.parse(a.sps).compareTo(double.parse(b.sps)));
  }

  void _sortDescendingBySalaryPSPrice() {
    _filteredProduction
        .sort((a, b) => double.parse(b.sps).compareTo(double.parse(a.sps)));
    _filteredProduction.forEach((prd) {
      print(prd.sps);
    });
  }

  void _sortAscendingSalary() {
    _filteredProduction.sort(
        (a, b) => double.parse(a.salary).compareTo(double.parse(b.salary)));
  }

  void _sortDescendingBySalary() {
    _filteredProduction.sort(
        (a, b) => double.parse(b.salary).compareTo(double.parse(a.salary)));
  }

  void _extractResult() {
    if (_query != "") {
      // String ecode = _emp.employees
      //     .where(
      //         (emps) => emps.ename.toLowerCase().contains(_query.toLowerCase()))
      //     .first
      //     .ecode;

      _filteredProduction = _pd.productions
          .where((pd) => pd.ename.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }
  }

  ViewProductionState _eventResult() {
    if (_filteredProduction.length > 0) {
      return ViewProductionLoadedState(_filteredProduction);
    } else {
      return ViewProductionErrorState("no data found");
    }
  }

  Future<void> loadProductions() async {
    _pd = await _viewProductionService.getAllProductions();

    _filteredProduction = _pd.productions.toList();
    print(_filteredProduction);
  }
}
