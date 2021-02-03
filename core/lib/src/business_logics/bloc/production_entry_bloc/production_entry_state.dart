part of 'production_entry_bloc.dart';

abstract class ProductionEntryState {
  const ProductionEntryState();
}

class ProductionIdle extends ProductionEntryState {}

class ProductionLoading extends ProductionEntryState {
  final bool status;
  final String message;

  ProductionLoading(this.status, this.message);
}

class ProductionSuccess extends ProductionEntryState {
  final bool status;
  final String message;

  ProductionSuccess(this.status, this.message);
}

class ProductionError extends ProductionEntryState {
  final bool status;
  final String message;

  ProductionError(this.status, this.message);
}

class ProductionErrorAndClear extends ProductionEntryState {
  final bool status;
  final String message;

  ProductionErrorAndClear(this.status, this.message);
}
