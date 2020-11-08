part of 'product_bloc.dart';

abstract class ProductState {
  const ProductState();
}

class ProductIdleState extends ProductState {}

class ProductSuccess extends ProductState {
  final bool status;
  final String message;

  ProductSuccess(this.status, this.message);
}

class ProductError extends ProductState {
  final bool status;
  final String message;

  ProductError(this.status, this.message);
}
