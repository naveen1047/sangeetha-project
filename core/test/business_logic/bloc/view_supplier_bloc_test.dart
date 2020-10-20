import 'package:bloc_test/bloc_test.dart';
import 'package:core/src/business_logics/bloc/view_supplier_bloc.dart';
import 'package:core/src/business_logics/models/supplier.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('View supplier Bloc test', () {
    ViewSupplierBloc viewSupplierBloc;
    List<Supplier> suppliers;

    setUp(() {
      viewSupplierBloc = ViewSupplierBloc();
      suppliers = Suppliers().suppliers;
    });

    setUpAll(() {
      setupServiceLocator();
    });

    tearDown(() {
      viewSupplierBloc.close();
    });

    test('initial state is loading', () {
      expect(viewSupplierBloc.state, ViewSupplierLoading());
    });

    blocTest(
      'should emit loading and loaded',
      build: () => viewSupplierBloc,
      act: (bloc) => bloc.add(FetchSupplierEvent()),
      expect: [
        ViewSupplierLoading(),
        ViewSupplierLoaded(suppliers),
      ],
    );
  });
}
