import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/material.dart';
import 'package:core/src/services/material_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';

enum sorting { ascending, descending }

// TODO: return state with value (sortBy, sorting)
enum sortBy { name, unit, price }

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

// event sorting
class SortMaterialByName extends ViewMaterialEvent {}

class SortMaterialByPrice extends ViewMaterialEvent {}

class SortMaterialByUnit extends ViewMaterialEvent {}

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

  // search key
  String _query = '';

  // sorting
  var sortByName = sorting.ascending;
  var sortByUnit = sorting.ascending;
  var sortByPrice = sorting.ascending;

  @override
  Stream<ViewMaterialState> mapEventToState(ViewMaterialEvent event) async* {
    if (event is FetchMaterialEvent) {
      yield* _mapFetchMaterialToState(event, event.mname);
    }
    if (event is SearchAndFetchMaterialEvent) {
      yield* _mapSearchAndFetchMaterialToState(event.mname);
    }
    if (event is SortMaterialByName) {
      yield* _mapSortMaterialByNameToState();
    }
    if (event is SortMaterialByUnit) {
      yield* _mapSortMaterialByUnitToState();
    }
    if (event is SortMaterialByPrice) {
      yield* _mapSortMaterialByPriceToState();
    }
  }

  // TODO: ugly state do sink and stream
  Stream<ViewMaterialState> _mapSearchAndFetchMaterialToState(
      String mname) async* {
    try {
      _query = mname;
      if (_query != null) {
        print(_query);
        _extractResult();
        if (sortByName == sorting.ascending) {
          _sortAscendingByMName();
        } else {
          _sortDescendingByMName();
        }
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
      _sortAscendingByMName();

      yield _eventResult();
    } catch (e) {
      yield MaterialErrorState(e.toString());
    }
  }

  /// TODO: sort materials by ( price) and yield result
  Stream<ViewMaterialState> _mapSortMaterialByNameToState() async* {
    try {
      _filteredMaterial = _materials.materials.toList();
      if (sortByName != sorting.ascending) {
        _extractResult();
        _sortAscendingByMName();
        sortByName = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByMName();
        sortByName = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield MaterialErrorState(e.toString());
    }
  }

  Stream<ViewMaterialState> _mapSortMaterialByUnitToState() async* {
    try {
      _filteredMaterial = _materials.materials.toList();
      if (sortByUnit != sorting.ascending) {
        _extractResult();
        _sortAscendingByMUnit();
        sortByUnit = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByMUnit();
        sortByUnit = sorting.descending;
      }
      yield _eventResult();
    } catch (e) {
      yield MaterialErrorState(e.toString());
    }
  }

  Stream<ViewMaterialState> _mapSortMaterialByPriceToState() async* {
    try {
      _filteredMaterial = _materials.materials.toList();
      if (sortByPrice != sorting.ascending) {
        _extractResult();
        _sortAscendingByMPrice();
        sortByPrice = sorting.ascending;
      } else {
        _extractResult();
        _sortDescendingByMPrice();
        sortByPrice = sorting.descending;
      }
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

  void _sortAscendingByMName() {
    _filteredMaterial
        .sort((a, b) => a.mname.toLowerCase().compareTo(b.mname.toLowerCase()));
  }

  void _sortDescendingByMName() {
    _filteredMaterial
        .sort((a, b) => b.mname.toLowerCase().compareTo(a.mname.toLowerCase()));
  }

  void _sortAscendingByMUnit() {
    _filteredMaterial
        .sort((a, b) => double.parse(a.munit).compareTo(double.parse(b.munit)));
  }

  void _sortDescendingByMUnit() {
    _filteredMaterial
        .sort((a, b) => double.parse(b.munit).compareTo(double.parse(a.munit)));
  }

  void _sortAscendingByMPrice() {
    _filteredMaterial.sort((a, b) =>
        double.parse(a.mpriceperunit).compareTo(double.parse(b.mpriceperunit)));
  }

  void _sortDescendingByMPrice() {
    _filteredMaterial.sort((a, b) =>
        double.parse(b.mpriceperunit).compareTo(double.parse(a.mpriceperunit)));
  }

  void _extractResult() {
    _filteredMaterial = _materials.materials
        .where((element) =>
            element.mname.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }
}
