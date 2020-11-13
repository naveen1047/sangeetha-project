import 'dart:convert';

import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/customer.dart';
import 'package:core/src/services/config.dart';
import 'package:core/src/services/customer_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CustomerServiceImpl implements CustomerService {
  String _baseUrl = kBaseUrl;

  @override
  Future<ResponseResult> submitCustomer(Customer customer) async {
    final data = customer.toJson();
    final url = "$_baseUrl/add_customer.php";
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
  Future<ResponseResult> editCustomerByCode(Customer customer) async {
    final data = customer.toJson();
    print(data.toString());
    final url = "$_baseUrl/edit_existing_customer.php";
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
  Future<ResponseResult> deleteCustomer(Map<String, dynamic> scode) async {
    final url = "$_baseUrl/delete_customer.php";
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
  Future<Customers> getAllCustomers() async {
    final url = "$_baseUrl/fetch_customer.php";
    var response = await http.get(url);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return compute(parseCustomers, response.body);
    } else {
      throw Exception(
          'Error Code: ${response.statusCode}\nWe were not able to successfully download the json data.');
    }
  }

  @override
  Future<Customer> getCustomerByName(String customerName) {
    // TODO: implement getCustomerByName
    throw UnimplementedError();
  }
}

Customers parseCustomers(String response) {
  return Customers.fromJson(json.decode(response));
}
