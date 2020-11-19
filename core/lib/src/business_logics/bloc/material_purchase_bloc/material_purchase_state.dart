part of 'material_purchase_bloc.dart';

abstract class MaterialPurchaseState {
  const MaterialPurchaseState();
}

class MaterialPurchaseIdleState extends MaterialPurchaseState {}

class PrerequisiteLoading extends MaterialPurchaseState {}

class PrerequisiteError extends MaterialPurchaseState {
  final String message;

  PrerequisiteError(this.message);
}

class PrerequisiteLoaded extends MaterialPurchaseState {
  final List<Supplier> suppliers;
  final List<Material> material;

  PrerequisiteLoaded(this.suppliers, this.material);
}

class MaterialPurchaseLoading extends MaterialPurchaseState {
  final bool status;
  final String message;

  MaterialPurchaseLoading(this.status, this.message);
}

class MaterialPurchaseSuccess extends MaterialPurchaseState {
  final bool status;
  final String message;

  MaterialPurchaseSuccess(this.status, this.message);
}

class MaterialPurchaseError extends MaterialPurchaseState {
  final bool status;
  final String message;

  MaterialPurchaseError(this.status, this.message);
}

class MaterialPurchaseErrorAndClear extends MaterialPurchaseState {
  final bool status;
  final String message;

  MaterialPurchaseErrorAndClear(this.status, this.message);
}
