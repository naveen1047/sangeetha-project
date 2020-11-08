part of 'view_material_bloc.dart';

abstract class ViewMaterialState {
  const ViewMaterialState();
}

class MaterialLoadingState extends ViewMaterialState {}

class MaterialLoadedState extends ViewMaterialState {
  final List<Material> materials;

  MaterialLoadedState(this.materials);
}

class MaterialErrorState extends ViewMaterialState {
  final String message;

  MaterialErrorState(this.message);

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [message];
}
