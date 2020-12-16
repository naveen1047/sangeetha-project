// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaterialPurchase _$MaterialPurchaseFromJson(Map<String, dynamic> json) {
  return MaterialPurchase(
    mname: json['mname'] as String,
    sname: json['sname'] as String,
    mpcode: json['mpcode'] as String,
    scode: json['scode'] as String,
    date: json['date'] as String,
    billno: json['billno'] as String,
    mcode: json['mcode'] as String,
    quantity: json['quantity'] as String,
    unitprice: json['unitprice'] as String,
    price: json['price'] as String,
    remarks: json['remarks'] as String,
  );
}

Map<String, dynamic> _$MaterialPurchaseToJson(MaterialPurchase instance) =>
    <String, dynamic>{
      'mpcode': instance.mpcode,
      'scode': instance.scode,
      'date': instance.date,
      'billno': instance.billno,
      'mcode': instance.mcode,
      'quantity': instance.quantity,
      'unitprice': instance.unitprice,
      'price': instance.price,
      'remarks': instance.remarks,
      'mname': instance.mname,
      'sname': instance.sname,
    };

MaterialPurchases _$MaterialPurchasesFromJson(Map<String, dynamic> json) {
  return MaterialPurchases(
    totalResults: json['totalResults'] as int,
    materialPurchases: (json['materialPurchases'] as List)
        ?.map((e) => e == null
            ? null
            : MaterialPurchase.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MaterialPurchasesToJson(MaterialPurchases instance) =>
    <String, dynamic>{
      'totalResults': instance.totalResults,
      'materialPurchases': instance.materialPurchases,
    };
