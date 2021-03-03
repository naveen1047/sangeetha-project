import 'package:bloc/bloc.dart';

import '../../../core.dart';

class ProductionWorker {
  String nosps;
  String sps;

  ProductionWorker(String nosps, String sps) {
    setPW(nosps, sps);
  }

  void setPW(String nosps, String sps) {
    this.nosps = nosps;
    this.sps = sps;
  }
}

class ProductionWorkerCubit extends Cubit<ProductionWorker> {
  ProductionWorkerCubit(ProductionWorker state)
      : super(ProductionWorker("0", "0"));

  void selectProduct(String sps, String nosps) => emit(_getValue(sps, nosps));
}

ProductionWorker _getValue(String sps, String nosps) {
  return ProductionWorker(nosps, sps);
}
