// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    cname: json['cname'] as String,
    ccode: json['ccode'] as String,
    cnum: json['cnum'] as String,
    caddress: json['caddress'] as String,
    caddate: json['caddate'] as String,
  );
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'cname': instance.cname,
      'ccode': instance.ccode,
      'cnum': instance.cnum,
      'caddress': instance.caddress,
      'caddate': instance.caddate,
    };

Customers _$CustomersFromJson(Map<String, dynamic> json) {
  return Customers(
    totalResults: json['totalResults'] as int,
    customers: (json['customers'] as List)
        ?.map((e) =>
            e == null ? null : Customer.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CustomersToJson(Customers instance) => <String, dynamic>{
      'totalResults': instance.totalResults,
      'customers': instance.customers,
    };
