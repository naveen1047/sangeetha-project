part of 'view_mp_bloc.dart';

abstract class ViewMPEvent extends Equatable {
  const ViewMPEvent();

  @override
  List<Object> get props => [];
}

class FetchMPEvent extends ViewMPEvent {
  final String mname;
  final String mcode;

  FetchMPEvent({this.mname, this.mcode});

  @override
  List<Object> get props => [mname];
}

class SearchAndFetchMPEvent extends ViewMPEvent {
  final String mname;
  final String mcode;

  SearchAndFetchMPEvent({this.mname, this.mcode});

  @override
  List<Object> get props => [mname];
}

// sorting
class SortMPByName extends ViewMPEvent {}

class SortMPByPrice extends ViewMPEvent {}

class SortMPByUnit extends ViewMPEvent {}
