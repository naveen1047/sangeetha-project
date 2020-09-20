import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/supplier.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:core/src/services/supplier_service.dart';
import 'package:equatable/equatable.dart';

// event
abstract class ViewSupplierEvent extends Equatable {
  const ViewSupplierEvent();

  @override
  List<Object> get props => [];
}

class FetchSupplierEvent extends ViewSupplierEvent {
  final String sname;
  final String scode;

  FetchSupplierEvent({
    this.sname,
    this.scode,
  });

  @override
  List<Object> get props => [sname];
}

class SearchAndFetchSupplierEvent extends ViewSupplierEvent {
  final String sname;
  final String scode;

  SearchAndFetchSupplierEvent({
    this.sname,
    this.scode,
  });

  @override
  List<Object> get props => [sname];
}

// state
abstract class ViewSupplierState {
  const ViewSupplierState();
}

class SupplierLoadingState extends ViewSupplierState {
  @override
  List<Object> get props => [];
}

class SupplierLoadedState extends ViewSupplierState {
  final List<Supplier> suppliers;

  SupplierLoadedState(this.suppliers);

  @override
  List<Object> get props => [];
}

class SupplierErrorState extends ViewSupplierState {
  final String message;

  SupplierErrorState(this.message);

  @override
  List<Object> get props => [message];
}

// bloc
class ViewSupplierBloc extends Bloc<ViewSupplierEvent, ViewSupplierState> {
  ViewSupplierBloc() : super(SupplierLoadingState());

  final SupplierService _viewSupplierService =
      serviceLocator<SupplierService>();

  Suppliers _suppliers;
  List<Supplier> _filteredSupplier;

  @override
  Stream<ViewSupplierState> mapEventToState(ViewSupplierEvent event) async* {
    if (event is FetchSupplierEvent) {
      yield* _mapFetchSupplierToState(event, event.sname);
    }
    if (event is SearchAndFetchSupplierEvent) {
      yield* _mapSearchAndFetchSupplierToState(event.sname);
    }
  }

  // TODO: ugly state do sink and stream
  Stream<ViewSupplierState> _mapSearchAndFetchSupplierToState(
      String sname) async* {
    try {
      if (sname != null) {
        print(sname);
        _filteredSupplier = _suppliers.suppliers
            .where((element) =>
                element.sname.toLowerCase().contains(sname.toLowerCase()))
            .toList();
        print(_filteredSupplier.toString());

        yield SupplierLoadedState(_filteredSupplier);
      }
    } catch (e) {
      yield SupplierErrorState(e.toString());
    }
  }

  Stream<ViewSupplierState> _mapFetchSupplierToState(
      ViewSupplierEvent event, String sname) async* {
    try {
      _suppliers = await _viewSupplierService.getAllSuppliers();

      yield SupplierLoadingState();

      _filteredSupplier = _suppliers.suppliers.toList();
      _filteredSupplier.sort(
          (a, b) => a.sname.toLowerCase().compareTo(b.sname.toLowerCase()));

      yield _eventResult();
    } catch (e) {
      yield SupplierErrorState(e.toString());
    }
  }

  ViewSupplierState _eventResult() {
    if (_filteredSupplier.length > 0) {
      return SupplierLoadedState(_filteredSupplier);
    } else {
      return SupplierErrorState("no data found");
    }
  }
}
