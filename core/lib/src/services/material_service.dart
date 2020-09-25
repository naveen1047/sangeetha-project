import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/material.dart';

abstract class MaterialService {
  Future<ResponseResult> submitMaterial(Material material);

  Future<ResponseResult> editMaterialByCode(Material material);

  Future<ResponseResult> deleteMaterial(Map<String, dynamic> mcode);

  Future<Materials> getAllMaterials();

  Future<Materials> getMaterialByName(String materialName);
}
