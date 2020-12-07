part of 'view_mp_bloc.dart';

abstract class ViewMPState {
  const ViewMPState();
}

class ViewMPLoadingState extends ViewMPState {}

class ViewMPLoadedState extends ViewMPState {
  final List<MaterialPurchase> materialPurchase;

  ViewMPLoadedState(this.materialPurchase);
}

class ViewMPErrorState extends ViewMPState {
  final String message;

  ViewMPErrorState(this.message);

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [message];
}
