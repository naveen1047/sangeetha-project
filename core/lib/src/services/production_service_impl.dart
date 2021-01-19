import 'dart:convert';

import 'package:core/src/business_logics/models/production.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/services/config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'production_service.dart';

class ProductionServiceImpl implements ProductionService {
  String _baseUrl = kBaseUrl;

  @override
  Future<ResponseResult> submitProduction(Production materialPurchase) async {
    final data = materialPurchase.toJson();
    final url = "$_baseUrl/add_production.php";
    print(data.toString());
    var response = await http.post(url, body: json.encode(data));
    print(response.headers);
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
  Future<ResponseResult> editProductionByCode(
      Production materialPurchase) async {
    final data = materialPurchase.toJson();
    print(data.toString());
    final url = "$_baseUrl/edit_production.php";
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
  Future<ResponseResult> deleteProduction(Map<String, dynamic> mpcode) async {
    final url = "$_baseUrl/delete_production.php";
    var response = await http.post(url, body: json.encode(mpcode));
    print('here');
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
  Future<Productions> getAllProductions() async {
    final url = "$_baseUrl/fetch_production.php";
    var response = await http.get(url);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return compute(parseProductions, response.body);
    } else {
      throw Exception(
          'Error Code: ${response.statusCode}\nWe were not able to successfully download the json data.');
    }
  }
}

Productions parseProductions(String response) {
  return Productions.fromJson(json.decode(response));
}
