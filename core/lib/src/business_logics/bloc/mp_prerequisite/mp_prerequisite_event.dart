part of 'mp_prerequisite_bloc.dart';

abstract class MPPrerequisiteEvent extends Equatable {
  const MPPrerequisiteEvent();

  @override
  List<Object> get props => [];
}

class GetMPPrerequisite extends MPPrerequisiteEvent {}
