import 'package:core/src/business_logics/models/material_purchase.dart';
import 'package:core/src/business_logics/models/response_result.dart';

abstract class MaterialPurchaseService {
  Future<ResponseResult> submitMaterialPurchase(MaterialPurchase material);

  Future<ResponseResult> editMaterialPurchaseByCode(MaterialPurchase material);

  Future<ResponseResult> deleteMaterialPurchase(Map<String, dynamic> mpcode);

  Future<MaterialPurchases> getAllMaterialPurchases();

  Future<MaterialPurchases> getMaterialPurchaseByName(
      String materialPurchaseName);
}
