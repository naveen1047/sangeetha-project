import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/employee.dart';
import 'package:core/src/business_logics/util/util.dart';
import 'package:core/src/services/employee_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';

part 'employee_event.dart';
part 'employee_state..dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeIdleState());

  final EmployeeService _employeeServices = serviceLocator<EmployeeService>();

  // get date
  String get getDateInFormat => generateDate();

  @override
  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
    if (event is AddEmployee) {
      yield* _mapAddEmployeeToState(event);
    } else if (event is EditEmployee) {
      yield* _mapEditEmployeeToState(event);
    } else if (event is DeleteEmployee) {
      yield* _mapDeleteEmployeeToState(event);
    }
  }

  Stream<EmployeeState> _mapAddEmployeeToState(AddEmployee event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      ResponseResult result =
          await _employeeServices.submitEmployee(_employee(event));
      if (result.status == true) {
        yield _success(result);
      } else {
        yield _errorAndClear(result);
      }
    } else {
      yield _nullValueError();
    }
  }

  Stream<EmployeeState> _mapEditEmployeeToState(EditEmployee event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      ResponseResult result =
          await _employeeServices.editEmployeeByCode(_employee(event));
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

  Stream<EmployeeState> _mapDeleteEmployeeToState(DeleteEmployee event) async* {
    Map<String, String> ecode = {'ecode': event.ecode};
    ResponseResult result = await _employeeServices.deleteEmployee(ecode);
    if (result.status == true) {
      yield _success(result);
    } else {
      yield _errorAndClear(result);
    }
  }

  bool _isEventAttributeIsNotNull(var event) {
    if (event.ename != '' && event.enumber != '' && event.eaddress != '') {
      return true;
    }
    return false;
  }

  Employee _employee(var event) {
    return Employee(
      ename: event.ename,
      eaddate: event.eaddate,
      eaddress: event.eaddress,
      ecode: event.ecode,
      enumber: event.enumber,
    );
  }

  EmployeeState _success(ResponseResult result) {
    return EmployeeSuccess(result.status, result.message);
  }

  EmployeeState _error(ResponseResult result) {
    return EmployeeError(result.status, result.message);
  }

  EmployeeState _nullValueError() {
    return EmployeeError(false, 'please fill required fields');
  }

  EmployeeState _loading() {
    return EmployeeLoading(true, "Uploading..");
  }

  EmployeeState _errorAndClear(ResponseResult result) {
    return EmployeeErrorAndClear(result.status, result.message);
  }
}
