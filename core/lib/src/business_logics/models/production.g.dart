// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Production _$ProductionFromJson(Map<String, dynamic> json) {
  return Production(
    pdcode: json['pdcode'] as String,
    date: json['date'] as String,
    pcode: json['pcode'] as String,
    ecode: json['ecode'] as String,
    sps: json['sps'] as String,
    nos: json['nos'] as String,
    nosps: json['nosps'] as String,
    salary: json['salary'] as String,
    remarks: json['remarks'] as String,
    pname: json['pname'] as String,
    ename: json['ename'] as String,
  );
}

Map<String, dynamic> _$ProductionToJson(Production instance) =>
    <String, dynamic>{
      'pdcode': instance.pdcode,
      'date': instance.date,
      'pcode': instance.pcode,
      'ecode': instance.ecode,
      'sps': instance.sps,
      'nos': instance.nos,
      'nosps': instance.nosps,
      'salary': instance.salary,
      'remarks': instance.remarks,
      'pname': instance.pname,
      'ename': instance.ename,
    };

Productions _$ProductionsFromJson(Map<String, dynamic> json) {
  return Productions(
    totalResults: json['totalResults'] as int,
    productions: (json['productions'] as List)
        ?.map((e) =>
            e == null ? null : Production.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ProductionsToJson(Productions instance) =>
    <String, dynamic>{
      'totalResults': instance.totalResults,
      'productions': instance.productions,
    };
