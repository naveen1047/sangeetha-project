import 'package:core/src/business_logics/models/product.dart';
import 'package:core/src/services/customer_service.dart';
import 'package:core/src/services/customer_service_impl.dart';
import 'package:core/src/services/employee_service.dart';
import 'package:core/src/services/employee_service_impl.dart';
import 'package:core/src/services/material_service.dart';
import 'package:core/src/services/material_service_impl.dart';
import 'package:core/src/services/product_service.dart';
import 'package:core/src/services/product_service_impl.dart';
import 'package:core/src/services/supplier_service.dart';
import 'package:core/src/services/supplier_service_impl.dart';
import 'package:get_it/get_it.dart';

import 'material_purchase_service.dart';
import 'material_purchase_service_impl.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // services
  // serviceLocator.registerLazySingleton<MaterialPurchaseServices>(
  //     () => FakeMaterialPurchase());
  serviceLocator
      .registerLazySingleton<ProductService>(() => ProductServiceImpl());

  serviceLocator.registerLazySingleton<MaterialPurchaseService>(
      () => MaterialPurchaseServiceImpl());

  serviceLocator
      .registerLazySingleton<CustomerService>(() => CustomerServiceImpl());

  serviceLocator
      .registerLazySingleton<EmployeeService>(() => EmployeeServiceImpl());

  serviceLocator
      .registerLazySingleton<MaterialService>(() => MaterialServiceImpl());

  serviceLocator
      .registerLazySingleton<SupplierService>(() => SupplierServiceImpl());
}
