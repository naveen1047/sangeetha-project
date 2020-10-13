// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) {
  return Employee(
    ename: json['ename'] as String,
    ecode: json['ecode'] as String,
    enumber: json['enumber'] as String,
    eaddress: json['eaddress'] as String,
    eaddate: json['eaddate'] as String,
  );
}

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'ename': instance.ename,
      'ecode': instance.ecode,
      'enumber': instance.enumber,
      'eaddress': instance.eaddress,
      'eaddate': instance.eaddate,
    };

Employees _$EmployeesFromJson(Map<String, dynamic> json) {
  return Employees(
    totalResults: json['totalResults'] as int,
    employees: (json['employees'] as List)
        ?.map((e) =>
            e == null ? null : Employee.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$EmployeesToJson(Employees instance) => <String, dynamic>{
      'totalResults': instance.totalResults,
      'employees': instance.employees,
    };
