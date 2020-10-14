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

@JsonSerializable()
class ResponseResults extends Equatable {
  final int totalResults;
  final List<ResponseResult> responseResults;

  ResponseResults({
    this.totalResults,
    this.responseResults,
  });

  factory ResponseResults.fromJson(Map<String, dynamic> json) =>
      _$ResponseResultsFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseResultsToJson(this);

  @override
  List<Object> get props => [totalResults, responseResults];
}
