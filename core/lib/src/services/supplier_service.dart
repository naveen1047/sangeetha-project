import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/supplier.dart';
import 'package:core/src/business_logics/models/supplier_name_code.dart';

abstract class SupplierService {
  Future<ResponseResult> submitSupplier(Supplier supplier);

  Future<ResponseResult> editSupplierByCode(Supplier supplier);

  Future<ResponseResult> deleteSupplier(Map<String, dynamic> scode);

  Future<Suppliers> getAllSuppliers();

  Future<SupplierNameCodes> getSupplierNameAndCode();

  Future<Supplier> getSupplierByName(String supplierName);
}
