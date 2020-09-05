import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/supplier.dart';
import 'package:core/src/services/supplier_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';

// event
abstract class AddSupplierEvent extends Equatable {
  const AddSupplierEvent();

  @override
  List<Object> get props => [];
}

class AddSupplier extends AddSupplierEvent {
  final String sname;
  final String scode;
  final String snum;
  final String saddress;
  final String saddate;

  AddSupplier({
    this.sname,
    this.scode,
    this.snum,
    this.saddress,
    this.saddate,
  });

  @override
  List<Object> get props => [sname, scode, snum, saddress, saddate];
}

// state
enum AddSupplierUpdateStatus { success, error }

class SupplierAddedState extends Equatable {
  final AddSupplierUpdateStatus status;

  const SupplierAddedState._({this.status});

  const SupplierAddedState.success()
      : this._(status: AddSupplierUpdateStatus.success);

  const SupplierAddedState.error()
      : this._(status: AddSupplierUpdateStatus.error);

  @override
  List<Object> get props => [status];
}

// bloc
class AddSupplierBloc extends Bloc<AddSupplierEvent, SupplierAddedState> {
  AddSupplierBloc() : super(null);

  final SupplierService _addSupplierServices =
      serviceLocator<SupplierService>();

  @override
  Stream<SupplierAddedState> mapEventToState(AddSupplierEvent event) async* {
    if (event is AddSupplier) {
      yield await _mapAddSupplierToState(event);
    }
  }

  Future<SupplierAddedState> _mapAddSupplierToState(AddSupplier event) async {
    bool result = await _addSupplierServices.submitSupplier(
      Supplier(
        sname: event.sname,
        saddate: event.saddate,
        saddress: event.saddress,
        scode: event.scode,
        snum: event.snum,
      ),
    );
    if (result == true) {
      return SupplierAddedState.success();
    }
    return SupplierAddedState.error();
  }
}
