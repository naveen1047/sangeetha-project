import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_result.g.dart';

@JsonSerializable()
class ResponseResult extends Equatable {
  final bool status;
  final String message;

  ResponseResult({
    this.status,
    this.message,
  });

  factory ResponseResult.fromJson(Map<String, dynamic> json) =>
      _$ResponseResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseResultToJson(this);

  @override
  List<Object> get props => [status, message];
}
