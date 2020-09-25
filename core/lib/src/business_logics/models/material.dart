import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'material.g.dart';

@JsonSerializable()
class Material extends Equatable {
  final String mname;
  final String mcode;
  final String munit;
  final String mpriceperunit;

  Material({
    this.mname,
    this.mcode,
    this.munit,
    this.mpriceperunit,
  });

  factory Material.fromJson(Map<String, dynamic> json) =>
      _$MaterialFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialToJson(this);

  @override
  List<Object> get props => [
        mname,
        mcode,
        munit,
        mpriceperunit,
      ];
}

@JsonSerializable()
class Materials extends Equatable {
  final int totalResults;
  final List<Material> materials;

  Materials({
    this.totalResults,
    this.materials,
  });

  factory Materials.fromJson(Map<String, dynamic> json) =>
      _$MaterialsFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialsToJson(this);

  @override
  List<Object> get props => [totalResults, materials];
}
