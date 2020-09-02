import 'package:core/src/business_logics/models/material_purchase.dart';
import 'package:core/src/services/material_purchase_service.dart';

class FakeMaterialPurchase implements MaterialPurchaseServices {
  @override
  Future<MaterialPurchase> getMaterialPurchaseEntryDetail() async {
    return MaterialPurchase(
      name: 'Sample',
      code: 'Sample',
      unit: 12.0,
      price: 12000.0,
    );
  }

  @override
  Future<bool> setMaterialPurchaseDetail(
      MaterialPurchase materialPurchase) async {
    return true;
  }
}
