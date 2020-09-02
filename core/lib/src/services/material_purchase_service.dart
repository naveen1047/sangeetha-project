import 'package:core/src/business_logics/models/material_purchase.dart';

abstract class MaterialPurchaseServices {
  Future<MaterialPurchase> getMaterialPurchaseEntryDetail();

  Future<bool> setMaterialPurchaseDetail(MaterialPurchase materialPurchase);
}
