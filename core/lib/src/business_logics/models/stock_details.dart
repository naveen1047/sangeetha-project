import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stock_details.g.dart';

@JsonSerializable()
class StockDetail extends Equatable {
  final String pcode;
  final String cstock;
  final String rstock;
  final String tstock;
  final String pname;

  StockDetail({
    this.pcode,
    this.cstock,
    this.rstock,
    this.tstock,
    this.pname,
  });

  factory StockDetail.fromJson(Map<String, dynamic> json) =>
      _$StockDetailFromJson(json);

  Map<String, dynamic> toJson() => _$StockDetailToJson(this);

  @override
  List<Object> get props => [
        pcode,
        pname,
        cstock,
        rstock,
        tstock,
      ];
}

@JsonSerializable()
class StockDetails extends Equatable {
  final int totalResults;
  final List<StockDetail> stocks;

  StockDetails({
    this.totalResults,
    this.stocks,
  });

  factory StockDetails.fromJson(Map<String, dynamic> json) =>
      _$StockDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$StockDetailsToJson(this);

  @override
  List<Object> get props => [totalResults, stocks];
}
