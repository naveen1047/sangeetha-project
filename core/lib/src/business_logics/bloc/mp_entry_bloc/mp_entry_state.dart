part of 'mp_entry_bloc.dart';

abstract class MPState {
  const MPState();
}

class MPIdle extends MPState {}

class MPLoading extends MPState {
  final bool status;
  final String message;

  MPLoading(this.status, this.message);
}

class MPSuccess extends MPState {
  final bool status;
  final String message;

  MPSuccess(this.status, this.message);
}

class MPError extends MPState {
  final bool status;
  final String message;

  MPError(this.status, this.message);
}

class MPErrorAndClear extends MPState {
  final bool status;
  final String message;

  MPErrorAndClear(this.status, this.message);
}
