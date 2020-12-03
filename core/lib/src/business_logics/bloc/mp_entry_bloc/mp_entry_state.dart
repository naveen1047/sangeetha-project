part of 'material_bloc.dart';

abstract class MaterialState {
  const MaterialState();
}

class MaterialLoading extends MaterialState {
  final bool status;
  final String message;

  MaterialLoading(this.status, this.message);
}

class MaterialSuccess extends MaterialState {
  final bool status;
  final String message;

  MaterialSuccess(this.status, this.message);
}

class MaterialError extends MaterialState {
  final bool status;
  final String message;

  MaterialError(this.status, this.message);
}

class MaterialErrorAndClear extends MaterialState {
  final bool status;
  final String message;

  MaterialErrorAndClear(this.status, this.message);
}
