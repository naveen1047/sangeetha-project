import 'package:core/src/business_logics/models/supplier.dart';

abstract class SupplierService {
  Future<bool> submitSupplier(Supplier supplier);
}
