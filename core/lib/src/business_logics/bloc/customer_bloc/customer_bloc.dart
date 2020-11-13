import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/customer.dart';
import 'package:core/src/business_logics/util/util.dart';
import 'package:core/src/services/customer_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';

part 'customer_event.dart';
part 'customer_state.dart';

// bloc
class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc() : super(CustomerIdleState());

  final CustomerService _customerServices = serviceLocator<CustomerService>();

  // get date
  String get getDateInFormat => generateDate();

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  Stream<CustomerState> mapEventToState(CustomerEvent event) async* {
    if (event is AddCustomer) {
      yield* _mapAddCustomerToState(event);
    } else if (event is EditCustomer) {
      yield* _mapEditCustomerToState(event);
    } else if (event is DeleteCustomer) {
      yield* _mapDeleteCustomerToState(event);
    }
  }

  Stream<CustomerState> _mapAddCustomerToState(AddCustomer event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      ResponseResult result =
          await _customerServices.submitCustomer(_customer(event));
      if (result.status == true) {
        yield _success(result);
      } else {
        yield _errorAndClear(result);
      }
    } else {
      yield _nullValueError();
    }
  }

  Stream<CustomerState> _mapEditCustomerToState(EditCustomer event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      ResponseResult result =
          await _customerServices.editCustomerByCode(_customer(event));
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

  Stream<CustomerState> _mapDeleteCustomerToState(DeleteCustomer event) async* {
    Map<String, String> ccode = {'ccode': event.ccode};
    ResponseResult result = await _customerServices.deleteCustomer(ccode);
    if (result.status == true) {
      yield _success(result);
    } else {
      yield _errorAndClear(result);
    }
  }

  bool _isEventAttributeIsNotNull(var event) {
    if (event.cname != '' && event.cnum != '' && event.caddress != '') {
      return true;
    } else {
      return false;
    }
  }

  Customer _customer(var event) {
    return Customer(
      cname: event.cname,
      caddate: event.caddate,
      caddress: event.caddress,
      ccode: event.ccode,
      cnum: event.cnum,
    );
  }

  CustomerState _loading() {
    return CustomerLoading(true, "Uploading..");
  }

  CustomerState _error(ResponseResult result) {
    return CustomerError(result.status, result.message);
  }

  CustomerState _success(ResponseResult result) {
    return CustomerSuccess(result.status, result.message);
  }

  CustomerState _errorAndClear(ResponseResult result) {
    return CustomerErrorAndClear(result.status, result.message);
  }

  CustomerState _nullValueError() {
    return CustomerError(false, 'please fill required fields');
  }
}
