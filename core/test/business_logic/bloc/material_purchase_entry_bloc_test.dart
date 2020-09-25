// import 'package:bloc_test/bloc_test.dart';
// import 'package:core/core.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// void main() {
//   group('MaterialPurchase entry Bloc test', () {
//     MaterialPurchaseEntryBloc materialPurchaseEntryBloc;
//
//     setUp(() {
//       materialPurchaseEntryBloc = MaterialPurchaseEntryBloc();
//     });
//
//     setUpAll(() {
//       setupServiceLocator();
//     });
//
//     tearDown(() {
//       materialPurchaseEntryBloc.close();
//     });
//
//     test('initial state is loading', () {
//       expect(materialPurchaseEntryBloc.state, null);
//     });
//
//     blocTest(
//       'should emit [success] when Materials added',
//       build: () => materialPurchaseEntryBloc,
//       act: (bloc) => bloc.add(AddMaterial(
//         name: '',
//         code: '',
//         unit: 1.1,
//         price: 1.1,
//       )),
//       expect: [MaterialAddedState.success()],
//     );
//   });
// }
