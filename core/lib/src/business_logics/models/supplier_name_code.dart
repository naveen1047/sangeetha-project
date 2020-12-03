import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'supplier_name_code.g.dart';

@JsonSerializable()
class SupplierNameCode extends Equatable {
  final String sname;
  final String scode;
  final String snum;

  SupplierNameCode({
    this.sname,
    this.scode,
    this.snum,
  });

  factory SupplierNameCode.fromJson(Map<String, dynamic> json) =>
      _$SupplierNameCodeFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierNameCodeToJson(this);

  @override
  List<Object> get props => [
        sname,
        scode,
        snum,
      ];
}

@JsonSerializable()
class SupplierNameCodes extends Equatable {
  final int totalResults;
  final List<SupplierNameCode> supplierNameCodes;

  SupplierNameCodes({
    this.totalResults,
    this.supplierNameCodes,
  });

  factory SupplierNameCodes.fromJson(Map<String, dynamic> json) =>
      _$SupplierNameCodesFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierNameCodesToJson(this);

  @override
  List<Object> get props => [totalResults, supplierNameCodes];
}
