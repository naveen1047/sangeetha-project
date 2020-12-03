import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:core/src/services/material_service.dart';
import 'package:core/src/services/supplier_service.dart';

import '../../../../core.dart';

part 'mp_prerequisite_state.dart';

part 'mp_prerequisite_event.dart';

class MPPrerequisiteBloc
    extends Bloc<MPPrerequisiteEvent, MPPrerequisiteState> {
  final SupplierService _viewSupplierService =
      serviceLocator<SupplierService>();

  final MaterialService _viewMaterialService =
      serviceLocator<MaterialService>();

  MPPrerequisiteBloc() : super(MPPrerequisiteLoading());

  SupplierNameCodes _suppliers;
  List<SupplierNameCode> _filteredSupplier;

  Materials _materials;
  List<Material> _filteredMaterial;

  @override
  Stream<MPPrerequisiteState> mapEventToState(
      MPPrerequisiteEvent event) async* {
    if (event is GetMPPrerequisite) {
      yield* _mapGetMPPrerequisite();
    }
  }

  Stream<MPPrerequisiteState> _mapGetMPPrerequisite() async* {
    try {
      yield MPPrerequisiteLoading();

      if (_suppliers == null || _materials == null) {
        _suppliers = await _viewSupplierService.getSupplierNameAndCode();
        _filteredSupplier = _suppliers.supplierNameCodes;
        _filteredSupplier.sort(
            (a, b) => a.sname.toLowerCase().compareTo(b.sname.toLowerCase()));

        _materials = await _viewMaterialService.getAllMaterials();
        _filteredMaterial = _materials.materials.toList();
        _filteredMaterial.sort(
            (a, b) => a.mname.toLowerCase().compareTo(b.mname.toLowerCase()));
      }
      if (_materials.totalResults < 1 ||
          _suppliers.supplierNameCodes.length < 1) {
        yield MPPrerequisiteError(
            "suppler or material is empty, You can't add material purchase");
      } else {
        yield MPPrerequisiteLoaded(
            _suppliers.supplierNameCodes, _materials.materials);
      }
    } catch (e) {
      yield MPPrerequisiteError(e.toString());
    }
  }
}
