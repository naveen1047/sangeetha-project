import 'package:core/core.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/services/production_service.dart';
import 'package:core/src/services/production_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Modify Production data', () {
    ProductionService _pServices;
    final Production production = Production(
      pdcode: "pdcode",
      date: "date",
      pcode: "edited",
      ecode: "ecode",
      sps: "sps",
      nos: "nos",
      nosps: "nosps",
      salary: "salary",
      remarks: "remarks",
    );

    setUp(() {
      _pServices = ProductionServiceImpl();
    });

    test('Add sample data', () async {
      ResponseResult resp = await _pServices.submitProduction(production);
      expect(resp.status, true);
    }, skip: true);

    test('Delete sample data', () async {
      ResponseResult resp =
          await _pServices.deleteProduction({"pdcode": "pdcode"});
      expect(resp.status, true);
    }, skip: true);

    test('Edit sample data', () async {
      ResponseResult resp = await _pServices.editProductionByCode(production);
      expect(resp.status, true);
    });
  });
}
