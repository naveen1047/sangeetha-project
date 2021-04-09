import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/stock_details.dart';

abstract class StockService {
  Future<ResponseResult> submitStock(StockDetail stock);

  Future<ResponseResult> editStockByCode(StockDetail stock);

  Future<StockDetails> getAllStocks();

  Future<StockDetails> getStockByName(String productName);
}
