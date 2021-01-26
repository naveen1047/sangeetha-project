part of 'production_prerequisite_bloc.dart';

abstract class ProductionPrerequisiteEvent extends Equatable {
  const ProductionPrerequisiteEvent();

  @override
  List<Object> get props => [];
}

class GetProductionPrerequisite extends ProductionPrerequisiteEvent {}
