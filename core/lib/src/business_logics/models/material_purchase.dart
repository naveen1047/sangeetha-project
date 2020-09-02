import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'material_purchase.g.dart';

@JsonSerializable()
class MaterialPurchase extends Equatable {
  final String name;
  final String code;
  final double unit;
  final double price;

  MaterialPurchase({this.name, this.code, this.unit, this.price});

  factory MaterialPurchase.fromJson(Map<String, dynamic> json) =>
      _$MaterialPurchaseFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialPurchaseToJson(this);

  @override
  List<Object> get props => [name, code, unit, price];
}
