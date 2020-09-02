import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/material_purchase.dart';
import 'package:core/src/services/material_purchase_service.dart';
import 'package:equatable/equatable.dart';

// event
abstract class MaterialPurchaseReportEvent extends Equatable {
  const MaterialPurchaseReportEvent();

  @override
  List<Object> get props => [];
}

class MaterialDetails extends MaterialPurchaseReportEvent {}

// state
enum MaterialLoadingStatus { success, error, loading }

class MaterialDetailsState extends Equatable {
  final MaterialLoadingStatus status;
  final MaterialPurchase materialPurchase;

  const MaterialDetailsState._({this.status, this.materialPurchase});

  const MaterialDetailsState.loading() : this._();

  const MaterialDetailsState.success(MaterialPurchase materialPurchase)
      : this._(
            status: MaterialLoadingStatus.success,
            materialPurchase: materialPurchase);

  const MaterialDetailsState.error()
      : this._(status: MaterialLoadingStatus.error);

  @override
  List<Object> get props => [status];
}

// bloc
class MaterialPurchaseReportBloc
    extends Bloc<MaterialPurchaseReportEvent, MaterialDetailsState> {
  MaterialPurchaseReportBloc(
      {MaterialPurchaseServices materialPurchaseServices})
      : _materialPurchaseServices = materialPurchaseServices,
        super(null);

  final MaterialPurchaseServices _materialPurchaseServices;

  @override
  Stream<MaterialDetailsState> mapEventToState(
      MaterialPurchaseReportEvent event) async* {
    if (event is MaterialDetails) {
      yield* _mapMaterialDetailsToState();
    }
  }

  Stream<MaterialDetailsState> _mapMaterialDetailsToState() async* {
    try {
      yield MaterialDetailsState.loading();
      MaterialPurchase _materialPurchase =
          await _materialPurchaseServices.getMaterialPurchaseEntryDetail();

      if (_materialPurchase != null) {
        yield MaterialDetailsState.success(_materialPurchase);
      }
    } catch (e) {
      yield MaterialDetailsState.error();
    }
  }
}
