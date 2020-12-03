// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_name_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierNameCode _$SupplierNameCodeFromJson(Map<String, dynamic> json) {
  return SupplierNameCode(
    sname: json['sname'] as String,
    scode: json['scode'] as String,
    snum: json['snum'] as String,
  );
}

Map<String, dynamic> _$SupplierNameCodeToJson(SupplierNameCode instance) =>
    <String, dynamic>{
      'sname': instance.sname,
      'scode': instance.scode,
      'snum': instance.snum,
    };

SupplierNameCodes _$SupplierNameCodesFromJson(Map<String, dynamic> json) {
  return SupplierNameCodes(
    totalResults: json['totalResults'] as int,
    supplierNameCodes: (json['supplierNameCodes'] as List)
        ?.map((e) => e == null
            ? null
            : SupplierNameCode.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SupplierNameCodesToJson(SupplierNameCodes instance) =>
    <String, dynamic>{
      'totalResults': instance.totalResults,
      'supplierNameCodes': instance.supplierNameCodes,
    };
