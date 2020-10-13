import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';

@JsonSerializable()
class Employee extends Equatable {
  final String ename;
  final String ecode;
  final String enumber;
  final String eaddress;
  final String eaddate;

  Employee({
    this.ename,
    this.ecode,
    this.enumber,
    this.eaddress,
    this.eaddate,
  });

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);

  @override
  List<Object> get props => [
        ename,
        ecode,
        enumber,
        eaddress,
        eaddate,
      ];
}

@JsonSerializable()
class Employees extends Equatable {
  final int totalResults;
  final List<Employee> employees;

  Employees({
    this.totalResults,
    this.employees,
  });

  factory Employees.fromJson(Map<String, dynamic> json) =>
      _$EmployeesFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeesToJson(this);

  @override
  List<Object> get props => [totalResults, employees];
}
