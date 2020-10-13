import 'package:core/src/services/employee_service.dart';
import 'package:core/src/services/employee_service_fake.dart';
import 'package:core/src/services/material_service.dart';
import 'package:core/src/services/material_service_fake.dart';
import 'package:core/src/services/supplier_service.dart';
import 'package:core/src/services/supplier_service_fake.dart';
import 'package:get_it/get_it.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // services
  // serviceLocator.registerLazySingleton<MaterialPurchaseServices>(
  //     () => FakeMaterialPurchase());
  serviceLocator
      .registerLazySingleton<EmployeeService>(() => EmployeeServiceFake());

  serviceLocator
      .registerLazySingleton<MaterialService>(() => MaterialServiceFake());

  serviceLocator
      .registerLazySingleton<SupplierService>(() => SupplierServiceFake());
}
