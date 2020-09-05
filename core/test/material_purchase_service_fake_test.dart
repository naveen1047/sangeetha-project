import 'package:core/core.dart';
import 'package:core/src/business_logics/models/material_purchase.dart';
import 'package:core/src/services/material_purchase_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Material purchase Service test', () {
    final materialFakeDetail = MaterialPurchase(
      name: 'Sample',
      code: 'Sample',
      unit: 12.0,
      price: 12000.0,
    );

    test('getMaterialPurchaseEntryDetail name should should equals fake data',
        () async {
      setupServiceLocator();
      final MaterialPurchaseServices fakeMaterialPurchase =
          serviceLocator<MaterialPurchaseServices>();

      final actualMaterialFakeDetail =
          await fakeMaterialPurchase.getMaterialPurchaseEntryDetail();

      expect(materialFakeDetail.name, actualMaterialFakeDetail.name);
    });
  });
}
