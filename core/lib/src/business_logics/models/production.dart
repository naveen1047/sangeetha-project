import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'production.g.dart';

@JsonSerializable()
class Production extends Equatable {
  final String pdcode;
  final String date;
  final String pcode;
  final String ecode;
  final String sps;
  final String nos;
  final String nosps;
  final String salary;
  final String remarks;
  final String pname;
  final String ename;

  Production({
    @required this.pdcode,
    @required this.date,
    @required this.pcode,
    @required this.ecode,
    @required this.sps,
    @required this.nos,
    @required this.nosps,
    @required this.salary,
    @required this.remarks,
    this.pname,
    this.ename,
  });

  factory Production.fromJson(Map<String, dynamic> json) =>
      _$ProductionFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionToJson(this);

  @override
  List<Object> get props => [
        pdcode,
        pcode,
        ecode,
      ];
}

@JsonSerializable()
class Productions extends Equatable {
  final int totalResults;
  final List<Production> productions;

  Productions({
    this.totalResults,
    this.productions,
  });

  factory Productions.fromJson(Map<String, dynamic> json) =>
      _$ProductionsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionsToJson(this);

  @override
  List<Object> get props => [totalResults, productions];
}
