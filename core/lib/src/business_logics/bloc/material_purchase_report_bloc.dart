import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/material_purchase.dart';
import 'package:core/src/services/material_purchase_service.dart';
import 'package:core/src/services/service_locator.dart';
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

class MaterialPurchaseReportState extends Equatable {
  final MaterialLoadingStatus status;
  final MaterialPurchase materialPurchase;

  const MaterialPurchaseReportState._({this.status, this.materialPurchase});

  const MaterialPurchaseReportState.loading()
      : this._(
          status: MaterialLoadingStatus.loading,
        );

  const MaterialPurchaseReportState.success(MaterialPurchase materialPurchase)
      : this._(
            status: MaterialLoadingStatus.success,
            materialPurchase: materialPurchase);

  const MaterialPurchaseReportState.error()
      : this._(status: MaterialLoadingStatus.error);

  @override
  List<Object> get props => [status];
}

// bloc
class MaterialPurchaseReportBloc
    extends Bloc<MaterialPurchaseReportEvent, MaterialPurchaseReportState> {
  MaterialPurchaseReportBloc() : super(MaterialPurchaseReportState.loading());

  final MaterialPurchaseServices _materialPurchaseServices =
      serviceLocator<MaterialPurchaseServices>();

  @override
  Stream<MaterialPurchaseReportState> mapEventToState(
      MaterialPurchaseReportEvent event) async* {
    if (event is MaterialDetails) {
      yield* _mapMaterialDetailsToState();
    }
  }

  Stream<MaterialPurchaseReportState> _mapMaterialDetailsToState() async* {
    try {
      yield MaterialPurchaseReportState.loading();
      MaterialPurchase _materialPurchase =
          await _materialPurchaseServices.getMaterialPurchaseEntryDetail();

      yield MaterialPurchaseReportState.success(_materialPurchase);
    } catch (e) {
      yield MaterialPurchaseReportState.error();
    }
  }
}
