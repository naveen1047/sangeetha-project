// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseResult _$ResponseResultFromJson(Map<String, dynamic> json) {
  return ResponseResult(
    status: json['status'] as bool,
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$ResponseResultToJson(ResponseResult instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };

ResponseResults _$ResponseResultsFromJson(Map<String, dynamic> json) {
  return ResponseResults(
    totalResults: json['totalResults'] as int,
    responseResults: (json['responseResults'] as List)
        ?.map((e) => e == null
            ? null
            : ResponseResult.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ResponseResultsToJson(ResponseResults instance) =>
    <String, dynamic>{
      'totalResults': instance.totalResults,
      'responseResults': instance.responseResults,
    };
