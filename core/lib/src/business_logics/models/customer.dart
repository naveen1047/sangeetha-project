import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer extends Equatable {
  final String cname;
  final String ccode;
  final String cnum;
  final String caddress;
  final String caddate;

  Customer({
    this.cname,
    this.ccode,
    this.cnum,
    this.caddress,
    this.caddate,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  @override
  List<Object> get props => [
        cname,
        ccode,
        cnum,
        caddress,
        caddate,
      ];
}

@JsonSerializable()
class Customers extends Equatable {
  final int totalResults;
  final List<Customer> customers;

  Customers({
    this.totalResults,
    this.customers,
  });

  factory Customers.fromJson(Map<String, dynamic> json) =>
      _$CustomersFromJson(json);

  Map<String, dynamic> toJson() => _$CustomersToJson(this);

  @override
  List<Object> get props => [totalResults, customers];
}
