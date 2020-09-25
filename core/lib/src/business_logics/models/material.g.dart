// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Material _$MaterialFromJson(Map<String, dynamic> json) {
  return Material(
    mname: json['mname'] as String,
    mcode: json['mcode'] as String,
    munit: json['munit'] as String,
    mpriceperunit: json['mpriceperunit'] as String,
  );
}

Map<String, dynamic> _$MaterialToJson(Material instance) => <String, dynamic>{
      'mname': instance.mname,
      'mcode': instance.mcode,
      'munit': instance.munit,
      'mpriceperunit': instance.mpriceperunit,
    };

Materials _$MaterialsFromJson(Map<String, dynamic> json) {
  return Materials(
    totalResults: json['totalResults'] as int,
    materials: (json['materials'] as List)
        ?.map((e) =>
            e == null ? null : Material.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MaterialsToJson(Materials instance) => <String, dynamic>{
      'totalResults': instance.totalResults,
      'materials': instance.materials,
    };
