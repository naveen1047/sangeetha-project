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
