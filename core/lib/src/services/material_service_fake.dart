import 'dart:convert';

import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/material.dart';
import 'package:core/src/services/material_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MaterialServiceFake implements MaterialService {
  String _baseUrl = "http://192.168.1.5/hb_php";

  @override
  Future<ResponseResult> submitMaterial(Material material) async {
    final data = material.toJson();
    final url = "$_baseUrl/add_material.php";
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
  Future<ResponseResult> editMaterialByCode(Material material) async {
    final data = material.toJson();
    print(data.toString());
    final url = "$_baseUrl/edit_existing_material.php";
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
  Future<ResponseResult> deleteMaterial(Map<String, dynamic> mcode) async {
    final url = "$_baseUrl/delete_material.php";
    var response = await http.post(url, body: json.encode(mcode));
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
  Future<Materials> getAllMaterials() async {
    final url = "$_baseUrl/fetch_material.php";
    var response = await http.get(url);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return compute(parseMaterials, response.body);
    } else {
      throw Exception(
          'Error Code: ${response.statusCode}\nWe were not able to successfully download the json data.');
    }
  }

  @override
  Future<Materials> getMaterialByName(String materialName) {
    // TODO: implement getMaterialByName
    throw UnimplementedError();
  }
}

Materials parseMaterials(String response) {
  return Materials.fromJson(json.decode(response));
}
