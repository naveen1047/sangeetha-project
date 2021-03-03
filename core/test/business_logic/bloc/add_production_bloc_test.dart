import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/src/business_logics/bloc/production_entry_bloc/production_entry_bloc.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/services/production_service.dart';
import 'package:core/src/services/production_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockProductionService extends Mock implements ProductionServiceImpl {}

void main() {
  group('add production Bloc test', () {
    ProductionEntryBloc productionEntryBloc;
    ProductionService _pServices;
    ProductionEntry sampleEntry;
    Production sampleData;

    Production _production(var event) {
      return Production(
        ecode: event.ecode,
        sps: event.sps,
        pdcode: event.pdcode,
        nosps: event.nosps,
        nos: event.nos,
        date: event.date,
        salary: event.salary,
        remarks: event.remarks,
        pcode: event.pcode,
      );
    }

    setUp(() {
      productionEntryBloc = ProductionEntryBloc();
      _pServices = MockProductionService();
      sampleEntry = ProductionEntry(
        pdcode: "null",
        date: "null",
        pcode: "null",
        ecode: "null",
        sps: "null",
        nos: "null",
        nosps: "null",
        salary: "null",
        remarks: "null",
      );
      sampleData = _production(sampleEntry);
    });

    setUpAll(() {
      setupServiceLocator();
    });

    tearDown(() {
      productionEntryBloc.close();
    });

    test('initial state is Idle', () {
      expect(productionEntryBloc.state, ProductionEntryIdle());
    });

    blocTest<ProductionEntryBloc, ProductionEntryState>(
      "emit [] when nothing is added",
      build: () {
        return ProductionEntryBloc();
      },
      expect: <ProductionEntryState>[],
    );

    blocTest<ProductionEntryBloc, ProductionEntryState>(
      "emit [ProductionError] when added",
      build: () {
        when(_pServices.submitProduction(sampleData)).thenAnswer(
          (_) => Future.value(
            ResponseResult(
                status: false,
                message: "Duplicate entry 'null' for key 'PRIMARY'"),
          ),
        );
        return ProductionEntryBloc();
      },
      act: (productionEntryBloc) async => productionEntryBloc.add(sampleEntry),
      expect: <ProductionEntryState>[
        // ProductionLoading(true, "Uploading..."),
        ProductionEntryError(false, "Duplicate entry 'null' for key 'PRIMARY'"),
      ],
      skip: 1,
    );

    blocTest<ProductionEntryBloc, ProductionEntryState>(
      "emit [ProductionSuccess] when edited",
      build: () {
        when(_pServices.editProductionByCode(sampleData)).thenAnswer(
          (value) => Future.value(
            ResponseResult(
                status: false,
                message: "Duplicate entry 'null' for key 'PRIMARY'"),
          ),
        );
        return ProductionEntryBloc();
      },
      act: (productionEntryBloc) async =>
          productionEntryBloc.add(EditProduction(
        pdcode: "null",
        date: "null",
        pcode: "null",
        ecode: "null",
        sps: "null",
        nos: "null",
        nosps: "null",
        salary: "edited",
        remarks: "null",
      )),
      expect: <ProductionEntryState>[
        ProductionEntryLoading(true, "Uploading..."),
        ProductionEntrySuccess(true, "null inserted"),
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
