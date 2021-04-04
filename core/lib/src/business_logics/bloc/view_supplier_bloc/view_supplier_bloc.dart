import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/supplier.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:core/src/services/supplier_service.dart';

part 'view_supplier_event.dart';
part 'view_supplier_state.dart';

class ViewSupplierBloc extends Bloc<ViewSupplierEvent, ViewSupplierState> {
  ViewSupplierBloc() : super(ViewSupplierLoading());

  final SupplierService _viewSupplierService =
      serviceLocator<SupplierService>();

  Suppliers _suppliers;
  List<Supplier> _filteredSupplier;

  @override
  Future<void> close() {
    _suppliers = null;
    _filteredSupplier?.clear();
    return super.close();
  }

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

        yield ViewSupplierLoaded(_filteredSupplier);
      }
    } catch (e) {
      yield ViewSupplierError(e.toString());
    }
  }

  Stream<ViewSupplierState> _mapFetchSupplierToState(
      ViewSupplierEvent event, String sname) async* {
    try {
      yield ViewSupplierLoading();
      _suppliers = await _viewSupplierService.getAllSuppliers();

      _filteredSupplier = _suppliers.suppliers.toList();
      _filteredSupplier.sort(
          (a, b) => a.sname.toLowerCase().compareTo(b.sname.toLowerCase()));

      yield _eventResult();
    } catch (e) {
      yield ViewSupplierError(e.toString());
    }
  }

  ViewSupplierState _eventResult() {
    if (_filteredSupplier.length > 0) {
      return ViewSupplierLoaded(_filteredSupplier);
    } else {
      return ViewSupplierError("no data found");
    }
  }
}
