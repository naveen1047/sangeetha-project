part of 'view_customer_bloc.dart';

abstract class ViewCustomerState {
  const ViewCustomerState();
}

class ViewCustomerLoading extends ViewCustomerState {
  // @override
  // List<Object> get props => [];
}

class ViewCustomerLoaded extends ViewCustomerState {
  final List<Customer> customers;

  ViewCustomerLoaded(this.customers);

  // @override
  // List<Object> get props => [];
}

class ViewCustomerError extends ViewCustomerState {
  final String message;

  ViewCustomerError(this.message);
  //
  // @override
  // List<Object> get props => [message];
}
