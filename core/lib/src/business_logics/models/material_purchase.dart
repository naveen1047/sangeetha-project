import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'material_purchase.g.dart';

@JsonSerializable()
class MaterialPurchase extends Equatable {
  final String mpcode;
  final String scode;
  final String date;
  final String billno;
  final String mcode;
  final String quantity;
  final String unitprice;
  final String price;
  final String remarks;

  MaterialPurchase({
    this.mpcode,
    this.scode,
    this.date,
    this.billno,
    this.mcode,
    this.quantity,
    this.unitprice,
    this.price,
    this.remarks,
  });

  factory MaterialPurchase.fromJson(Map<String, dynamic> json) =>
      _$MaterialPurchaseFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialPurchaseToJson(this);

  @override
  List<Object> get props => [mpcode];
}

@JsonSerializable()
class MaterialPurchases extends Equatable {
  final int totalResults;
  final List<MaterialPurchase> materialPurchases;

  MaterialPurchases({
    this.totalResults,
    this.materialPurchases,
  });

  factory MaterialPurchases.fromJson(Map<String, dynamic> json) =>
      _$MaterialPurchasesFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialPurchasesToJson(this);

  @override
  List<Object> get props => [totalResults, materialPurchases];
}
