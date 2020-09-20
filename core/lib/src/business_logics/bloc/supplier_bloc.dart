import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/supplier.dart';
import 'package:core/src/services/supplier_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';

// event
abstract class SupplierEvent extends Equatable {
  const SupplierEvent();

  @override
  List<Object> get props => [];
}

class AddSupplier extends SupplierEvent {
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

class EditSupplier extends SupplierEvent {
  final String sname;
  final String scode;
  final String snum;
  final String saddress;
  final String saddate;

  EditSupplier({
    this.sname,
    this.scode,
    this.snum,
    this.saddress,
    this.saddate,
  });

  @override
  List<Object> get props => [sname, scode, snum, saddress, saddate];
}

class DeleteSupplier extends SupplierEvent {
  final String scode;

  DeleteSupplier({
    this.scode,
  });

  @override
  List<Object> get props => [];
}

// state
abstract class SupplierState {
  const SupplierState();
}

class IdleState extends SupplierState {}

class SupplierSuccess extends SupplierState {
  final bool status;
  final String message;

  SupplierSuccess(this.status, this.message);
}

class SupplierError extends SupplierState {
  final bool status;
  final String message;

  SupplierError(this.status, this.message);
}

// bloc
class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  SupplierBloc() : super(IdleState());

  final SupplierService _supplierServices = serviceLocator<SupplierService>();

  // get date
  String get getDateInFormat {
    String day = DateTime.now().day < 10
        ? '0${DateTime.now().day}'
        : '${DateTime.now().day}';
    String month = DateTime.now().month < 10
        ? '0${DateTime.now().month}'
        : '${DateTime.now().month}';
    int year = DateTime.now().year;
    return '$day-$month-$year';
  }

  @override
  Stream<SupplierState> mapEventToState(SupplierEvent event) async* {
    if (event is AddSupplier) {
      yield* _mapAddSupplierToState(event);
    } else if (event is EditSupplier) {
      yield* _mapEditSupplierToState(event);
    } else if (event is DeleteSupplier) {
      yield* _mapDeleteSupplierToState(event);
    }
  }

  Stream<SupplierState> _mapAddSupplierToState(AddSupplier event) async* {
    if (event.sname != '' && event.snum != '' && event.saddress != '') {
      ResponseResult result = await _supplierServices.submitSupplier(
        Supplier(
          sname: event.sname,
          saddate: event.saddate,
          saddress: event.saddress,
          scode: event.scode,
          snum: event.snum,
        ),
      );
      if (result.status == true) {
        yield SupplierSuccess(result.status, result.message);
      } else {
        yield SupplierError(result.status, result.message);
      }
    } else {
      yield SupplierError(false, 'please fill required fields');
    }
  }

  Stream<SupplierState> _mapEditSupplierToState(EditSupplier event) async* {
    if (event.sname != '' && event.snum != '' && event.saddress != '') {
      ResponseResult result = await _supplierServices.editSupplierByCode(
        Supplier(
          sname: event.sname,
          saddate: event.saddate,
          saddress: event.saddress,
          scode: event.scode,
          snum: event.snum,
        ),
      );
      if (result.status == true) {
        yield SupplierSuccess(result.status, result.message);
      } else {
        yield SupplierError(result.status, result.message);
      }
    } else {
      yield SupplierError(false, 'please fill required fields');
    }
  }

  Stream<SupplierState> _mapDeleteSupplierToState(DeleteSupplier event) async* {
    Map<String, String> scode = {'scode': event.scode};
    print(scode.toString());
    ResponseResult result = await _supplierServices.deleteSupplier(scode);
    if (result.status == true) {
      yield SupplierSuccess(result.status, result.message);
    } else {
      yield SupplierError(result.status, result.message);
    }
  }
}

// scode cubit
class ScodeCubit extends Cubit<String> {
  ScodeCubit(String state) : super('');

  void generate(String sname) => emit(_convertToCode(sname));

  String _convertToCode(String text) {
    if (text == '' || text == null) return '';
    text = text
        .replaceAll("_", "")
        .split(new RegExp(r"[\s-]"))
        .map((word) => word.length > 1 ? word[0] : word)
        .map((letter) => letter.toUpperCase())
        .where((item) => item.contains(new RegExp(r"[A-Z]")))
        .reduce((result, item) => result + item);
    text += Random().nextInt(99).toString();
    text += Random().nextInt(9).toString();
    text += String.fromCharCode((Random().nextInt(26) + 65));
    return text;
  }
}
