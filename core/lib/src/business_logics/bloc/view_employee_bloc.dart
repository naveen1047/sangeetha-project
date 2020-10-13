import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/employee.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:core/src/services/employee_service.dart';
import 'package:equatable/equatable.dart';

// event
abstract class ViewEmployeeEvent extends Equatable {
  const ViewEmployeeEvent();

  @override
  List<Object> get props => [];
}

class FetchEmployeeEvent extends ViewEmployeeEvent {
  final String ename;
  final String ecode;

  FetchEmployeeEvent({
    this.ename,
    this.ecode,
  });

  @override
  List<Object> get props => [ename];
}

class SearchAndFetchEmployeeEvent extends ViewEmployeeEvent {
  final String ename;
  final String ecode;

  SearchAndFetchEmployeeEvent({
    this.ename,
    this.ecode,
  });

  @override
  List<Object> get props => [ename];
}

// state
abstract class ViewEmployeeState {
  const ViewEmployeeState();
}

class EmployeeLoadingState extends ViewEmployeeState {
  @override
  List<Object> get props => [];
}

class EmployeeLoadedState extends ViewEmployeeState {
  final List<Employee> employees;

  EmployeeLoadedState(this.employees);

  @override
  List<Object> get props => [];
}

class EmployeeErrorState extends ViewEmployeeState {
  final String message;

  EmployeeErrorState(this.message);

  @override
  List<Object> get props => [message];
}

// bloc
class ViewEmployeeBloc extends Bloc<ViewEmployeeEvent, ViewEmployeeState> {
  ViewEmployeeBloc() : super(EmployeeLoadingState());

  final EmployeeService _viewEmployeeService =
      serviceLocator<EmployeeService>();

  Employees _employees;
  List<Employee> _filteredEmployee;

  @override
  Stream<ViewEmployeeState> mapEventToState(ViewEmployeeEvent event) async* {
    if (event is FetchEmployeeEvent) {
      yield* _mapFetchEmployeeToState(event, event.ename);
    }
    if (event is SearchAndFetchEmployeeEvent) {
      yield* _mapSearchAndFetchEmployeeToState(event.ename);
    }
  }

  // TODO: ugly state do sink and stream
  Stream<ViewEmployeeState> _mapSearchAndFetchEmployeeToState(
      String ename) async* {
    try {
      if (ename != null) {
        print(ename);
        _filteredEmployee = _employees.employees
            .where((element) =>
                element.ename.toLowerCase().contains(ename.toLowerCase()))
            .toList();
        print(_filteredEmployee.toString());

        yield EmployeeLoadedState(_filteredEmployee);
      }
    } catch (e) {
      yield EmployeeErrorState(e.toString());
    }
  }

  Stream<ViewEmployeeState> _mapFetchEmployeeToState(
      ViewEmployeeEvent event, String ename) async* {
    try {
      _employees = await _viewEmployeeService.getAllEmployees();

      yield EmployeeLoadingState();

      _filteredEmployee = _employees.employees.toList();
      _filteredEmployee.sort(
          (a, b) => a.ename.toLowerCase().compareTo(b.ename.toLowerCase()));

      yield _eventResult();
    } catch (e) {
      yield EmployeeErrorState(e.toString());
    }
  }

  ViewEmployeeState _eventResult() {
    if (_filteredEmployee.length > 0) {
      return EmployeeLoadedState(_filteredEmployee);
    } else {
      return EmployeeErrorState("no data found");
    }
  }
}
