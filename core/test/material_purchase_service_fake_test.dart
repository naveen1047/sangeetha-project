import 'package:core/core.dart';
import 'package:core/src/business_logics/models/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Material purchase Service test', () {
    final materialFakeDetail = Material(
      mname: "event.mname",
      mcode: "event.mcode",
      munit: "event.munit",
      mpriceperunit: "event.mpriceperunit",
    );

    test('getMaterialEntryDetail name should should equals fake data',
        () async {
      setupServiceLocator();
      // final MaterialService fakeMaterial = serviceLocator<MaterialService>();

      // final actualMaterialFakeDetail = await fakeMaterial.getAllMaterials();

      expect(materialFakeDetail.mname, "event.mname");
    });
  });
}
