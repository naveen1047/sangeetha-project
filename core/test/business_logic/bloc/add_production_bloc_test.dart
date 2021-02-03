import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/src/business_logics/bloc/production_entry_bloc/production_entry_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('add production Bloc test', () {
    ProductionEntryBloc productionEntryBloc;
    Production production;

    setUp(() {
      productionEntryBloc = ProductionEntryBloc();
      production = Production(
          pdcode: "null",
          date: "null",
          pcode: "null",
          ecode: "null",
          sps: "null",
          nos: "null",
          nosps: "null",
          salary: "null",
          remarks: "null");
    });

    setUpAll(() {
      setupServiceLocator();
    });

    tearDown(() {
      productionEntryBloc.close();
    });

    test('initial state is Idle', () {
      expect(productionEntryBloc.state.toString(), ProductionIdle().toString());
    });

    // test('should return today date', () {
    //   String testDate = addSupplierBloc.getDateInFormat;
    //   expect('2021-02-03', testDate);
    // });

    blocTest<ProductionEntryBloc, ProductionEntryState>(
      "emit [] when nothing is added",
      build: () {
        return ProductionEntryBloc();
      },
      expect: <ProductionEntryState>[],
    );

    blocTest<ProductionEntryBloc, ProductionEntryState>(
      "emit [ProductionSuccess] when added",
      build: () {
        return ProductionEntryBloc();
      },
      act: (bloc) async => bloc.add(ProductionEntry(
        pdcode: "null",
        date: "null",
        pcode: "null",
        ecode: "null",
        sps: "null",
        nos: "null",
        nosps: "null",
        salary: "null",
        remarks: "null",
      )),
      expect: <ProductionEntryState>[
        ProductionLoading(true, "Uploading..."),
        ProductionError(false, "message"),
      ],
    );
    // blocTest("should emit loading and loaded", build: null);
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
