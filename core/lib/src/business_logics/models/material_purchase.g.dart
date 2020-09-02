// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaterialPurchase _$MaterialPurchaseFromJson(Map<String, dynamic> json) {
  return MaterialPurchase(
    name: json['name'] as String,
    code: json['code'] as String,
    unit: (json['unit'] as num)?.toDouble(),
    price: (json['price'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$MaterialPurchaseToJson(MaterialPurchase instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'unit': instance.unit,
      'price': instance.price,
    };
