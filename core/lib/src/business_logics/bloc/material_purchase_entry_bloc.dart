// import 'package:bloc/bloc.dart';
// import 'package:core/src/business_logics/models/material.dart';
// import 'package:core/src/services/material_purchase_service.dart';
// import 'package:core/src/services/service_locator.dart';
// import 'package:equatable/equatable.dart';
//
// // event
// abstract class MaterialPurchaseEntryEvent extends Equatable {
//   const MaterialPurchaseEntryEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class AddMaterial extends MaterialPurchaseEntryEvent {
//   final String name;
//   final String code;
//   final double unit;
//   final double price;
//
//   AddMaterial({this.name, this.code, this.unit, this.price});
//
//   @override
//   List<Object> get props => [name, code, unit, price];
// }
//
// // state
// enum MaterialUpdateStatus { success, error }
//
// class MaterialAddedState extends Equatable {
//   final MaterialUpdateStatus status;
//
//   const MaterialAddedState._({this.status});
//
//   const MaterialAddedState.success()
//       : this._(status: MaterialUpdateStatus.success);
//
//   const MaterialAddedState.error() : this._(status: MaterialUpdateStatus.error);
//
//   @override
//   List<Object> get props => [status];
// }
//
// // bloc
// class MaterialPurchaseEntryBloc
//     extends Bloc<MaterialPurchaseEntryEvent, MaterialAddedState> {
//   MaterialPurchaseEntryBloc() : super(null);
//
//   final MaterialPurchaseServices _materialPurchaseServices =
//       serviceLocator<MaterialPurchaseServices>();
//
//   @override
//   Stream<MaterialAddedState> mapEventToState(
//       MaterialPurchaseEntryEvent event) async* {
//     if (event is AddMaterial) {
//       yield await _mapAddMaterialToState(event);
//     }
//   }
//
//   Future<MaterialAddedState> _mapAddMaterialToState(AddMaterial event) async {
//     bool result = await _materialPurchaseServices.setMaterialPurchaseDetail(
//       MaterialPurchase(
//         name: event.name,
//         code: event.code,
//         unit: event.unit,
//         price: event.price,
//       ),
//     );
//
//     if (result == true) {
//       return MaterialAddedState.success();
//     }
//     return MaterialAddedState.error();
//   }
// }
