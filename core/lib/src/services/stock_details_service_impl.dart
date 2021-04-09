import 'dart:convert';

import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/stock_details.dart';
import 'package:core/src/services/config.dart';
import 'package:core/src/services/stock_details_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StockServiceImpl implements StockService {
  String _baseUrl = kBaseUrl;

  @override
  Future<ResponseResult> submitStock(StockDetail stock) async {
    final data = stock.toJson();
    final url = "$_baseUrl/add_stock_detail.php";
    var response = await http.post(url, body: json.encode(data));
    print(response.body.toString());
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return ResponseResult.fromJson(result);
    } else {
      throw Exception(
          ' Error Code: ${response.statusCode}\nWe were not able to successfully download the json data.');
    }
  }

  @override
  Future<ResponseResult> editStockByCode(StockDetail stock) async {
    final data = stock.toJson();
    print(data.toString());
    final url = "$_baseUrl/edit_stock_details.php";
    var response = await http.post(url, body: json.encode(data));
    print(response.body.toString());
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return ResponseResult.fromJson(result);
    } else {
      throw Exception(
          'We were not able to successfully download the json data.');
    }
  }

  @override
  Future<StockDetails> getAllStocks() async {
    final url = "$_baseUrl/fetch_stock_details.php";
    var response = await http.get(url);
    print(response.request.url.toString());
    print(response.body.toString());
    if (response.statusCode == 200) {
      return compute(parseStocks, response.body);
    } else {
      throw Exception(
          'Error Code: ${response.statusCode}\nWe were not able to successfully download the json data.');
    }
  }

  @override
  Future<StockDetails> getStockByName(String productName) {
    // TODO: implement getStockByName
    throw UnimplementedError();
  }
}

StockDetails parseStocks(String response) {
  return StockDetails.fromJson(json.decode(response));
}
