// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockDetail _$StockDetailFromJson(Map<String, dynamic> json) {
  return StockDetail(
    pcode: json['pcode'] as String,
    cstock: json['cstock'] as String,
    rstock: json['rstock'] as String,
    tstock: json['tstock'] as String,
    pname: json['pname'] as String,
  );
}

Map<String, dynamic> _$StockDetailToJson(StockDetail instance) =>
    <String, dynamic>{
      'pcode': instance.pcode,
      'cstock': instance.cstock,
      'rstock': instance.rstock,
      'tstock': instance.tstock,
      'pname': instance.pname,
    };

StockDetails _$StockDetailsFromJson(Map<String, dynamic> json) {
  return StockDetails(
    totalResults: json['totalResults'] as int,
    stocks: (json['stocks'] as List)
        ?.map((e) =>
            e == null ? null : StockDetail.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$StockDetailsToJson(StockDetails instance) =>
    <String, dynamic>{
      'totalResults': instance.totalResults,
      'stocks': instance.stocks,
    };
