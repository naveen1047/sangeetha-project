import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/material.dart';
import 'package:core/src/services/material_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';

// event
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

// state
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

// bloc
class ViewMaterialBloc extends Bloc<ViewMaterialEvent, ViewMaterialState> {
  ViewMaterialBloc() : super(MaterialLoadingState());

  final MaterialService _viewMaterialService =
      serviceLocator<MaterialService>();

  Materials _materials;
  List<Material> _filteredMaterial;

  @override
  Stream<ViewMaterialState> mapEventToState(ViewMaterialEvent event) async* {
    if (event is FetchMaterialEvent) {
      yield* _mapFetchMaterialToState(event, event.mname);
    }
    if (event is SearchAndFetchMaterialEvent) {
      yield* _mapSearchAndFetchMaterialToState(event.mname);
    }
  }

  // TODO: ugly state do sink and stream
  Stream<ViewMaterialState> _mapSearchAndFetchMaterialToState(
      String mname) async* {
    try {
      if (mname != null) {
        print(mname);
        _filteredMaterial = _materials.materials
            .where((element) =>
                element.mname.toLowerCase().contains(mname.toLowerCase()))
            .toList();
        print(_filteredMaterial.toString());

        yield MaterialLoadedState(_filteredMaterial);
      }
    } catch (e) {
      yield MaterialErrorState(e.toString());
    }
  }

  Stream<ViewMaterialState> _mapFetchMaterialToState(
      ViewMaterialEvent event, String mname) async* {
    try {
      _materials = await _viewMaterialService.getAllMaterials();

      yield MaterialLoadingState();

      _filteredMaterial = _materials.materials.toList();
      _filteredMaterial.sort(
          (a, b) => a.mname.toLowerCase().compareTo(b.mname.toLowerCase()));

      yield _eventResult();
    } catch (e) {
      yield MaterialErrorState(e.toString());
    }
  }

  ViewMaterialState _eventResult() {
    if (_filteredMaterial.length > 0) {
      return MaterialLoadedState(_filteredMaterial);
    } else {
      return MaterialErrorState("no data found");
    }
  }
}
