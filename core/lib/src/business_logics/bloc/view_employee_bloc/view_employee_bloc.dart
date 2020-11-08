import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/employee.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:core/src/services/employee_service.dart';
import 'package:equatable/equatable.dart';

part 'view_employee_event.dart';
part 'view_employee_state.dart';

// bloc
class ViewEmployeeBloc extends Bloc<ViewEmployeeEvent, ViewEmployeeState> {
  ViewEmployeeBloc() : super(ViewEmployeeLoading());

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

        yield ViewEmployeeLoaded(_filteredEmployee);
      }
    } catch (e) {
      yield ViewEmployeeError(e.toString());
    }
  }

  Stream<ViewEmployeeState> _mapFetchEmployeeToState(
      ViewEmployeeEvent event, String ename) async* {
    try {
      yield ViewEmployeeLoading();

      _employees = await _viewEmployeeService.getAllEmployees();
      _filteredEmployee = _employees.employees.toList();
      _filteredEmployee.sort(
          (a, b) => a.ename.toLowerCase().compareTo(b.ename.toLowerCase()));

      yield _eventResult();
    } catch (e) {
      yield ViewEmployeeError(e.toString());
    }
  }

  ViewEmployeeState _eventResult() {
    if (_filteredEmployee.length > 0) {
      return ViewEmployeeLoaded(_filteredEmployee);
    } else {
      return ViewEmployeeError("no data found");
    }
  }
}
