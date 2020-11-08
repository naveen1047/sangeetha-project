import 'package:core/src/business_logics/bloc/supplier_bloc/supplier_bloc.dart';
import 'package:core/src/business_logics/models/supplier.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('add supplier Bloc test', () {
    SupplierBloc addSupplierBloc;
    Suppliers suppliers;

    setUp(() {
      addSupplierBloc = SupplierBloc();
      suppliers = Suppliers();
    });

    setUpAll(() {
      setupServiceLocator();
    });

    tearDown(() {
      addSupplierBloc.close();
    });

    test('should return today date', () {
      String testDate = addSupplierBloc.getDateInFormat;
      expect('08-09-2020', testDate);
    });

//    test('initial state is loading', () {
//      expect(viewSupplierBloc.state, SupplierLoadingState());
//    });

//    blocTest(
//      'should emit loading and loaded',
//      build: () => addSupplierBloc,
//      act: (bloc) => bloc.add(FetchSupplierEvent()),
//      expect: [
//        SupplierLoadingState(),
//        SupplierLoadedState(suppliers),
//      ],
//    );
  });
}
