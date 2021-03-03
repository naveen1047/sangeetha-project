import 'package:core/core.dart';
import 'package:core/src/services/production_service.dart';
import 'package:core/src/services/production_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Fetch Production data', () {
    ProductionService _pServices;

    setUp(() {
      _pServices = ProductionServiceImpl();
    });

    test('Should return at least one data while fetching data', () async {
      Productions productions = await _pServices.getAllProductions();
      expect(productions.totalResults > 0, true);
    });
  });
}
