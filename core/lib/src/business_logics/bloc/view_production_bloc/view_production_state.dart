part of 'view_production_bloc.dart';

abstract class ViewProductionState extends Equatable {
  const ViewProductionState();

  @override
  List<Object> get props => [];
}

class ViewProductionLoadingState extends ViewProductionState {}

class ViewProductionLoadedState extends ViewProductionState {
  final List<Production> production;

  ViewProductionLoadedState(this.production);
}

class ViewProductionErrorState extends ViewProductionState {
  final String message;

  ViewProductionErrorState(this.message);
}
