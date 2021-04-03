part of 'view_supplier_bloc.dart';

abstract class ViewSupplierState extends Equatable {
  const ViewSupplierState();

  @override
  List<Object> get props => [];
}

class ViewSupplierLoading extends ViewSupplierState {}

class ViewSupplierLoaded extends ViewSupplierState {
  final List<Supplier> suppliers;

  ViewSupplierLoaded(this.suppliers);

  // @override
  // List<Object> get props => [];
}

class ViewSupplierError extends ViewSupplierState {
  final String message;

  ViewSupplierError(this.message);

  // @override
  // List<Object> get props => [message];
}
