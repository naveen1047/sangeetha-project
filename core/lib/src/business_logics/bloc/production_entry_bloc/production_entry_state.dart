part of 'production_entry_bloc.dart';

abstract class ProductionEntryState extends Equatable {
  const ProductionEntryState();

  @override
  List<Object> get props => [];
}

class ProductionEntryIdle extends ProductionEntryState {}

class ProductionEntryLoading extends ProductionEntryState {
  final bool status;
  final String message;

  ProductionEntryLoading(this.status, this.message);
}

class ProductionEntrySuccess extends ProductionEntryState {
  final bool status;
  final String message;

  ProductionEntrySuccess(this.status, this.message);
}

class ProductionEntryError extends ProductionEntryState {
  final bool status;
  final String message;

  ProductionEntryError(this.status, this.message);
}

class ProductionEntryErrorAndClear extends ProductionEntryState {
  final bool status;
  final String message;

  ProductionEntryErrorAndClear(this.status, this.message);
}
