part of 'production_prerequisite_bloc.dart';

abstract class ProductionPrerequisiteState {
  const ProductionPrerequisiteState();
}

class ProductionPrerequisiteLoading extends ProductionPrerequisiteState {}

class ProductionPrerequisiteError extends ProductionPrerequisiteState {
  final String message;

  ProductionPrerequisiteError(this.message);
}

class ProductionPrerequisiteLoaded extends ProductionPrerequisiteState {
  final List<Product> products;
  final List<Employee> employee;

  ProductionPrerequisiteLoaded(this.employee, this.products);
}
