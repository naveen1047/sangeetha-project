import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/supplier.dart';

abstract class SupplierService {
  Future<ResponseResult> submitSupplier(Supplier supplier);

  Future<ResponseResult> editSupplierByCode(Supplier supplier);

  Future<ResponseResult> deleteSupplier(Map<String, dynamic> scode);

  Future<Suppliers> getAllSuppliers();

  Future<Supplier> getSupplierByName(String supplierName);
}
