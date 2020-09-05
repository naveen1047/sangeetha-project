import 'dart:convert';

import 'package:core/src/business_logics/models/supplier.dart';
import 'package:core/src/services/supplier_service.dart';
import 'package:http/http.dart' as http;

class SupplierServiceFake implements SupplierService {
  @override
  Future<bool> submitSupplier(Supplier supplier) async {
    print(supplier.sname);
    downloadJSON(
      sname: supplier.sname,
      scode: supplier.scode,
      snum: supplier.snum,
    );
    return true;
  }

  Future<void> downloadJSON({String sname, String scode, String snum}) async {
    final data = {'sname': sname, 'scode': scode, 'snum': snum};
    final url = "http://sangeethagroups.000webhostapp.com/get.php";

    var response = await http.post(url, body: json.encode(data));
//    final response = await get(jsonEndpoint);
//    var message = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      print(result.toString());
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
  }
}
