// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Supplier _$SupplierFromJson(Map<String, dynamic> json) {
  return Supplier(
    sname: json['sname'] as String,
    scode: json['scode'] as String,
    snum: json['snum'] as String,
    saddress: json['saddress'] as String,
    saddate: json['saddate'] as String,
  );
}

Map<String, dynamic> _$SupplierToJson(Supplier instance) => <String, dynamic>{
      'sname': instance.sname,
      'scode': instance.scode,
      'snum': instance.snum,
      'saddress': instance.saddress,
      'saddate': instance.saddate,
    };

Suppliers _$SuppliersFromJson(Map<String, dynamic> json) {
  return Suppliers(
    totalResults: json['totalResults'] as int,
    suppliers: (json['suppliers'] as List)
        ?.map((e) =>
            e == null ? null : Supplier.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SuppliersToJson(Suppliers instance) => <String, dynamic>{
      'totalResults': instance.totalResults,
      'suppliers': instance.suppliers,
    };
