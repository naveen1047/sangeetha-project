import 'dart:convert';

import 'package:core/src/business_logics/models/material_purchase.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/services/config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'material_purchase_service.dart';

class MaterialPurchaseServiceImpl implements MaterialPurchaseService {
  String _baseUrl = kBaseUrl;

  @override
  Future<ResponseResult> submitMaterialPurchase(
      MaterialPurchase materialPurchase) async {
    final data = materialPurchase.toJson();
    final url = "$_baseUrl/add_material_purchase.php";
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
  Future<ResponseResult> editMaterialPurchaseByCode(
      MaterialPurchase materialPurchase) async {
    final data = materialPurchase.toJson();
    print(data.toString());
    final url = "$_baseUrl/edit_existing_material_purchase.php";
    var response = await http.post(url, body: json.encode(data));
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return ResponseResult.fromJson(result);
    } else {
      throw Exception(
          'We were not able to successfully download the json data.');
    }
  }

  @override
  Future<ResponseResult> deleteMaterialPurchase(
      Map<String, dynamic> mpcode) async {
    final url = "$_baseUrl/delete_material_purchase.php";
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
  Future<MaterialPurchases> getAllMaterialPurchases() async {
    final url = "$_baseUrl/fetch_material_purchase.php";
    var response = await http.get(url);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return compute(parseMaterialPurchases, response.body);
    } else {
      throw Exception(
          'Error Code: ${response.statusCode}\nWe were not able to successfully download the json data.');
    }
  }

  @override
  Future<MaterialPurchases> getMaterialPurchaseByName(
      String materialPurchaseName) {
    // TODO: implement getMaterialPurchaseByName
    throw UnimplementedError();
  }
}

MaterialPurchases parseMaterialPurchases(String response) {
  return MaterialPurchases.fromJson(json.decode(response));
}
