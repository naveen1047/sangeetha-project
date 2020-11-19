import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/material_purchase.dart';
import 'package:core/src/business_logics/util/util.dart';
import 'package:core/src/services/material_purchase_service.dart';
import 'package:core/src/services/material_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:core/src/services/supplier_service.dart';
import 'package:equatable/equatable.dart';

part 'material_purchase_event.dart';

part 'material_purchase_state.dart';

// bloc
class MaterialPurchaseBloc
    extends Bloc<MaterialPurchaseEvent, MaterialPurchaseState> {
  MaterialPurchaseBloc() : super(MaterialPurchaseIdleState());

  final MaterialPurchaseService _materialPurchaseServices =
      serviceLocator<MaterialPurchaseService>();

  final SupplierService _viewSupplierService =
      serviceLocator<SupplierService>();

  final MaterialService _viewMaterialService =
      serviceLocator<MaterialService>();

  final _dateController = StreamController<String>();

  Stream<String> get getDateInFormat => _dateController.stream;

  Suppliers _suppliers;
  List<Supplier> _filteredSupplier;

  Materials _materials;
  List<Material> _filteredMaterial;

  String date;

  @override
  Future<void> close() {
    _dateController.close();
    return super.close();
  }

  @override
  Stream<MaterialPurchaseState> mapEventToState(
      MaterialPurchaseEvent event) async* {
    if (event is FetchPrerequisite) {
      yield* _mapFetchPrerequisite();
    } else if (event is AddMaterialPurchase) {
      yield* _mapAddMaterialPurchaseToState(event);
    } else if (event is EditMaterialPurchase) {
      yield* _mapEditMaterialPurchaseToState(event);
    } else if (event is DeleteMaterialPurchase) {
      yield* _mapDeleteMaterialPurchaseToState(event);
    } else if (event is SetDate) {
      yield* _mapSetDateToState(event);
    }
  }

  Stream<MaterialPurchaseState> _mapSetDateToState(SetDate event) async* {
    try {
      if (event.dateTime == null) {
        date = generateDate();
      } else {
        date = generateDate(selectedDate: event.dateTime);
      }
      yield GetDate(date);
    } catch (e) {
      yield PrerequisiteError(e.toString());
    }
  }

  Stream<MaterialPurchaseState> _mapFetchPrerequisite() async* {
    try {
      yield PrerequisiteLoading();
      _suppliers = await _viewSupplierService.getAllSuppliers();

      _filteredSupplier = _suppliers.suppliers.toList();
      _filteredSupplier.sort(
          (a, b) => a.sname.toLowerCase().compareTo(b.sname.toLowerCase()));

      _materials = await _viewMaterialService.getAllMaterials();

      _filteredMaterial = _materials.materials.toList();
      _filteredMaterial.sort(
          (a, b) => a.mname.toLowerCase().compareTo(b.mname.toLowerCase()));

      yield _eventResult();
    } catch (e) {
      yield PrerequisiteError(e.toString());
    }
  }

  Stream<MaterialPurchaseState> _mapAddMaterialPurchaseToState(
      AddMaterialPurchase event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      ResponseResult result = await _materialPurchaseServices
          .submitMaterialPurchase(_materialPurchase(event));
      if (result.status == true) {
        yield _success(result);
      } else {
        yield _errorAndClear(result);
      }
    } else {
      yield _nullValueError();
    }
  }

  Stream<MaterialPurchaseState> _mapEditMaterialPurchaseToState(
      EditMaterialPurchase event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      ResponseResult result = await _materialPurchaseServices
          .editMaterialPurchaseByCode(_materialPurchase(event));
      await Future.delayed(Duration(seconds: 1));
      if (result.status == true) {
        yield _success(result);
      } else {
        yield _errorAndClear(result);
      }
    } else {
      yield _nullValueError();
    }
  }

  Stream<MaterialPurchaseState> _mapDeleteMaterialPurchaseToState(
      DeleteMaterialPurchase event) async* {
    Map<String, String> scode = {'scode': event.scode};
    ResponseResult result =
        await _materialPurchaseServices.deleteMaterialPurchase(scode);
    if (result.status == true) {
      yield _success(result);
    } else {
      yield _errorAndClear(result);
    }
  }

  bool _isEventAttributeIsNotNull(var event) {
    if (event.sname != '' && event.snum != '' && event.saddress != '') {
      return true;
    } else {
      return false;
    }
  }

  MaterialPurchase _materialPurchase(var event) {
    return MaterialPurchase(
      mpcode: event.mpcode,
      scode: event.scode,
      date: event.date,
      billno: event.billno,
      mcode: event.mcode,
      quantity: event.quantity,
      unitprice: event.unitprice,
      price: event.price,
      remarks: event.remarks,
    );
  }

  MaterialPurchaseState _loading() {
    return MaterialPurchaseLoading(true, "Uploading..");
  }

  MaterialPurchaseState _error(ResponseResult result) {
    return MaterialPurchaseError(result.status, result.message);
  }

  MaterialPurchaseState _success(ResponseResult result) {
    return MaterialPurchaseSuccess(result.status, result.message);
  }

  MaterialPurchaseState _errorAndClear(ResponseResult result) {
    return MaterialPurchaseErrorAndClear(result.status, result.message);
  }

  MaterialPurchaseState _nullValueError() {
    return MaterialPurchaseError(false, 'please fill required fields');
  }

  MaterialPurchaseState _eventResult() {
    if (_filteredSupplier.length >= 0 && _filteredMaterial.length >= 0) {
      return PrerequisiteLoaded(_filteredSupplier, _filteredMaterial);
    } else {
      return PrerequisiteError(
          "Material or Supplier  is empty, You can't add data");
    }
  }
}
