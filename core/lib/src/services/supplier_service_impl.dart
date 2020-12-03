import 'dart:convert';

import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/supplier.dart';
import 'package:core/src/business_logics/models/supplier_name_code.dart';
import 'package:core/src/services/config.dart';
import 'package:core/src/services/supplier_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SupplierServiceImpl implements SupplierService {
  String _baseUrl = kBaseUrl;

  @override
  Future<ResponseResult> submitSupplier(Supplier supplier) async {
    final data = supplier.toJson();
    final url = "$_baseUrl/add_supplier.php";
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
  Future<ResponseResult> editSupplierByCode(Supplier supplier) async {
    final data = supplier.toJson();
    print(data.toString());
    final url = "$_baseUrl/edit_existing_supplier.php";
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
  Future<ResponseResult> deleteSupplier(Map<String, dynamic> scode) async {
    final url = "$_baseUrl/delete_supplier.php";
    var response = await http.post(url, body: json.encode(scode));
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
  Future<Suppliers> getAllSuppliers() async {
    final url = "$_baseUrl/fetch_supplier.php";
    var response = await http.get(url);
    print(response.request.url.toString());
    print(response.body.toString());
    if (response.statusCode == 200) {
      return compute(parseSuppliers, response.body);
    } else {
      throw Exception(
          'Error Code: ${response.statusCode}\nWe were not able to successfully download the json data.');
    }
  }

  @override
  Future<Supplier> getSupplierByName(String supplierName) {
    // TODO: implement getSupplierByName
    throw UnimplementedError();
  }

  @override
  Future<SupplierNameCodes> getSupplierNameAndCode() async {
    final url = "$_baseUrl/fetch_supplier_name_code.php";
    var response = await http.get(url);
    print(response.request.url.toString());
    print(response.body.toString());
    if (response.statusCode == 200) {
      return compute(parseSupplierNameCodes, response.body);
    } else {
      throw Exception(
          'Error Code: ${response.statusCode}\nWe were not able to successfully download the json data.');
    }
  }
}

Suppliers parseSuppliers(String response) {
  return Suppliers.fromJson(json.decode(response));
}

SupplierNameCodes parseSupplierNameCodes(String response) {
  return SupplierNameCodes.fromJson(json.decode(response));
}
