import 'package:core/src/business_logics/models/stock_details.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:core/src/services/stock_details_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fetch stocks', () {
    StockServiceImpl serviceImpl;
    StockDetails stockDetails;

    setUp(() {
      serviceImpl = StockServiceImpl();
    });

    test('fetch stocks by getAllStocks', () async {
      stockDetails = await serviceImpl.getAllStocks();
      expect(stockDetails.totalResults > 0, true);
    });
  });
}
