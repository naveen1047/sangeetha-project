part of 'view_material_bloc.dart';

abstract class ViewMaterialEvent extends Equatable {
  const ViewMaterialEvent();

  @override
  List<Object> get props => [];
}

class FetchMaterialEvent extends ViewMaterialEvent {
  final String mname;
  final String mcode;

  FetchMaterialEvent({this.mname, this.mcode});

  @override
  List<Object> get props => [mname];
}

class SearchAndFetchMaterialEvent extends ViewMaterialEvent {
  final String mname;
  final String mcode;

  SearchAndFetchMaterialEvent({this.mname, this.mcode});

  @override
  List<Object> get props => [mname];
}

// sorting
class SortMaterialByName extends ViewMaterialEvent {}

class SortMaterialByPrice extends ViewMaterialEvent {}

class SortMaterialByUnit extends ViewMaterialEvent {}
