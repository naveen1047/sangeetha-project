part of 'mp_prerequisite_bloc.dart';

abstract class MPPrerequisiteState {
  const MPPrerequisiteState();
}

class MPPrerequisiteLoading extends MPPrerequisiteState {}

class MPPrerequisiteError extends MPPrerequisiteState {
  final String message;

  MPPrerequisiteError(this.message);
}

class MPPrerequisiteLoaded extends MPPrerequisiteState {
  final List<SupplierNameCode> suppliers;
  final List<Material> material;

  MPPrerequisiteLoaded(this.suppliers, this.material);
}
