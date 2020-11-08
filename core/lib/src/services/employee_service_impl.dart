import 'dart:convert';

import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/employee.dart';
import 'package:core/src/services/config.dart';
import 'package:core/src/services/employee_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class EmployeeServiceFake implements EmployeeService {
  String _baseUrl = kBaseUrl;

  @override
  Future<ResponseResult> submitEmployee(Employee employee) async {
    final data = employee.toJson();
    final url = "$_baseUrl/add_employee.php";
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
  Future<ResponseResult> editEmployeeByCode(Employee employee) async {
    final data = employee.toJson();
    print(data.toString());
    final url = "$_baseUrl/edit_existing_employee.php";
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
  Future<ResponseResult> deleteEmployee(Map<String, dynamic> scode) async {
    final url = "$_baseUrl/delete_employee.php";
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
  Future<Employees> getAllEmployees() async {
    final url = "$_baseUrl/fetch_employee.php";
    var response = await http.get(url);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return compute(parseEmployees, response.body);
    } else {
      throw Exception(
          'Error Code: ${response.statusCode}\nWe were not able to successfully download the json data.');
    }
  }

  @override
  Future<Employee> getEmployeeByName(String employeeName) {
    // TODO: implement getEmployeeByName
    throw UnimplementedError();
  }
}

Employees parseEmployees(String response) {
  return Employees.fromJson(json.decode(response));
}
