import 'package:core/src/business_logics/models/production.dart';
import 'package:core/src/business_logics/models/response_result.dart';

abstract class ProductionService {
  Future<ResponseResult> submitProduction(Production production);

  Future<ResponseResult> editProductionByCode(Production production);

  Future<ResponseResult> deleteProduction(Map<String, dynamic> pdcode);

  Future<Productions> getAllProductions();
}
