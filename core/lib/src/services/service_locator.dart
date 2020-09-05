import 'package:core/src/services/supplier_service.dart';
import 'package:core/src/services/supplier_service_fake.dart';
import 'package:core/src/services/material_purchase_service.dart';
import 'package:core/src/services/material_purchase_service_fake.dart';
import 'package:get_it/get_it.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // services
  serviceLocator.registerLazySingleton<MaterialPurchaseServices>(
      () => FakeMaterialPurchase());

  serviceLocator
      .registerLazySingleton<SupplierService>(() => SupplierServiceFake());
}
