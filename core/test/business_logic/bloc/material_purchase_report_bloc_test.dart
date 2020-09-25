// import 'package:bloc_test/bloc_test.dart';
// import 'package:core/core.dart';
// import 'package:core/src/business_logics/bloc/material_purchase_report_bloc.dart';
// import 'package:core/src/business_logics/models/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// void main() {
//   group('MaterialPurchase Report Bloc test', () {
//     MaterialPurchaseReportBloc materialPurchaseReportBloc;
//     MaterialPurchase materialPurchase;
//
//     setUp(() {
//       materialPurchaseReportBloc = MaterialPurchaseReportBloc();
//       materialPurchase = MaterialPurchase(
//         name: 'Sample',
//         code: 'Sample',
//         unit: 12.0,
//         price: 12000.0,
//       );
//     });
//
//     setUpAll(() {
//       setupServiceLocator();
//     });
//
//     tearDown(() {
//       materialPurchaseReportBloc.close();
//     });
//
//     test('initial state is loading', () {
//       expect(materialPurchaseReportBloc.state.status,
//           MaterialLoadingStatus.loading);
//     });
//
//     blocTest(
//       'should emit [success] when MaterialDetails fetched',
//       build: () => materialPurchaseReportBloc,
//       act: (bloc) => bloc.add(MaterialDetails()),
//       expect: [
//         MaterialPurchaseReportState.loading(),
//         MaterialPurchaseReportState.success(materialPurchase)
//       ],
//     );
//   });
// }
