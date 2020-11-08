import 'dart:convert';

import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/product.dart';
import 'package:core/src/services/config.dart';
import 'package:core/src/services/product_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProductServiceImpl implements ProductService {
  String _baseUrl = kBaseUrl;

  @override
  Future<ResponseResults> submitProduct(Product product) async {
    final data = product.toJson();
    final url = "$_baseUrl/add_product.php";
    var response = await http.post(url, body: json.encode(data));
    // print(response.body.toString());
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return ResponseResults.fromJson(result);
    } else {
      throw Exception(
          ' Error Code: ${response.statusCode}\nWe were not able to successfully download the json data.');
    }
  }

  @override
  Future<ResponseResult> editProductByCode(Product product) async {
    final data = product.toJson();
    print(data.toString());
    final url = "$_baseUrl/edit_existing_product.php";
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
  Future<ResponseResult> deleteProduct(Map<String, dynamic> scode) async {
    final url = "$_baseUrl/delete_product.php";
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
  Future<Products> getAllProducts() async {
    final url = "$_baseUrl/fetch_product.php";
    var response = await http.get(url);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return compute(parseProducts, response.body);
    } else {
      throw Exception(
          'Error Code: ${response.statusCode}\nWe were not able to successfully download the json data.');
    }
  }

  @override
  Future<Product> getProductByName(String productName) {
    // TODO: implement getProductByName
    throw UnimplementedError();
  }
}

Products parseProducts(String response) {
  return Products.fromJson(json.decode(response));
}
