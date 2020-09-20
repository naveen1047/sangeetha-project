import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'supplier.g.dart';

@JsonSerializable()
class Supplier extends Equatable {
  final String sname;
  final String scode;
  final String snum;
  final String saddress;
  final String saddate;

  Supplier({
    this.sname,
    this.scode,
    this.snum,
    this.saddress,
    this.saddate,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierToJson(this);

  @override
  List<Object> get props => [
        sname,
        scode,
        snum,
        saddress,
        saddate,
      ];
}

@JsonSerializable()
class Suppliers extends Equatable {
  final int totalResults;
  final List<Supplier> suppliers;

  Suppliers({
    this.totalResults,
    this.suppliers,
  });

  factory Suppliers.fromJson(Map<String, dynamic> json) =>
      _$SuppliersFromJson(json);

  Map<String, dynamic> toJson() => _$SuppliersToJson(this);

  @override
  List<Object> get props => [totalResults, suppliers];
}
