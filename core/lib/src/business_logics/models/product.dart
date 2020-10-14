import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product extends Equatable {
  final String pname;
  final String pcode;
  final String salaryps;
  final String nosps;
  final String sunit;
  final String pricepersunit;
  final String nospsunit;

  Product({
    this.pname,
    this.pcode,
    this.salaryps,
    this.nosps,
    this.sunit,
    this.pricepersunit,
    this.nospsunit,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  List<Object> get props => [
        pname,
        pcode,
        salaryps,
        nosps,
        sunit,
        pricepersunit,
        nospsunit,
      ];
}

@JsonSerializable()
class Products extends Equatable {
  final int totalResults;
  final List<Product> products;

  Products({
    this.totalResults,
    this.products,
  });

  factory Products.fromJson(Map<String, dynamic> json) =>
      _$ProductsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsToJson(this);

  @override
  List<Object> get props => [totalResults, products];
}
