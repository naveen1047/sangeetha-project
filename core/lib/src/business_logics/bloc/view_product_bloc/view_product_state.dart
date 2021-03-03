part of 'view_product_bloc.dart';

abstract class ViewProductState extends Equatable {
  const ViewProductState();

  @override
  List<Object> get props => [];
}

class ProductLoadingState extends ViewProductState {}

class ProductLoadedState extends ViewProductState {
  final List<Product> products;

  ProductLoadedState(this.products);
}

class ProductErrorState extends ViewProductState {
  final String message;

  ProductErrorState(this.message);

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [message];
}
