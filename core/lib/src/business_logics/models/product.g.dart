// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    pname: json['pname'] as String,
    pcode: json['pcode'] as String,
    salaryps: json['salaryps'] as String,
    nosps: json['nosps'] as String,
    sunit: json['sunit'] as String,
    pricepersunit: json['pricepersunit'] as String,
    nospsunit: json['nospsunit'] as String,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'pname': instance.pname,
      'pcode': instance.pcode,
      'salaryps': instance.salaryps,
      'nosps': instance.nosps,
      'sunit': instance.sunit,
      'pricepersunit': instance.pricepersunit,
      'nospsunit': instance.nospsunit,
    };

Products _$ProductsFromJson(Map<String, dynamic> json) {
  return Products(
    totalResults: json['totalResults'] as int,
    products: (json['products'] as List)
        ?.map((e) =>
            e == null ? null : Product.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ProductsToJson(Products instance) => <String, dynamic>{
      'totalResults': instance.totalResults,
      'products': instance.products,
    };
