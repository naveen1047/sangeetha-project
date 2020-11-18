import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/customer.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:core/src/services/customer_service.dart';

part 'view_customer_event.dart';
part 'view_customer_state.dart';

class ViewCustomerBloc extends Bloc<ViewCustomerEvent, ViewCustomerState> {
  ViewCustomerBloc() : super(ViewCustomerLoading());

  final CustomerService _viewCustomerService =
      serviceLocator<CustomerService>();

  Customers _customers;
  List<Customer> _filteredCustomer;

  @override
  Future<void> close() {
    _customers = null;
    _filteredCustomer?.clear();
    return super.close();
  }

  @override
  Stream<ViewCustomerState> mapEventToState(ViewCustomerEvent event) async* {
    if (event is FetchCustomerEvent) {
      yield* _mapFetchCustomerToState(event, event.cname);
    }
    if (event is SearchAndFetchCustomerEvent) {
      yield* _mapSearchAndFetchCustomerToState(event.cname);
    }
  }

  // TODO: ugly state do sink and stream

  Stream<ViewCustomerState> _mapSearchAndFetchCustomerToState(
      String cname) async* {
    try {
      if (cname != null) {
        print(cname);
        _filteredCustomer = _customers.customers
            .where((element) =>
                element.cname.toLowerCase().contains(cname.toLowerCase()))
            .toList();
        print(_filteredCustomer.toString());

        yield ViewCustomerLoaded(_filteredCustomer);
      }
    } catch (e) {
      yield ViewCustomerError(e.toString());
    }
  }

  Stream<ViewCustomerState> _mapFetchCustomerToState(
      ViewCustomerEvent event, String cname) async* {
    try {
      yield ViewCustomerLoading();
      _customers = await _viewCustomerService.getAllCustomers();

      _filteredCustomer = _customers.customers.toList();
      _filteredCustomer.sort(
          (a, b) => a.cname.toLowerCase().compareTo(b.cname.toLowerCase()));

      yield _eventResult();
    } catch (e) {
      yield ViewCustomerError(e.toString());
    }
  }

  ViewCustomerState _eventResult() {
    if (_filteredCustomer.length > 0) {
      return ViewCustomerLoaded(_filteredCustomer);
    } else {
      return ViewCustomerError("no data found");
    }
  }
}
