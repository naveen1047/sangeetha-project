import 'package:bloc_test/bloc_test.dart';
import 'package:core/src/business_logics/bloc/view_stock_details_bloc/view_stock_details_bloc.dart';
import 'package:core/src/business_logics/models/stock_details.dart';
import 'package:core/src/business_logics/util/constants.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('View supplier Bloc test', () {
    ViewStockDetailsBloc viewStockDetailsBloc;
    List<StockDetail> stocks;

    setUp(() {
      viewStockDetailsBloc = ViewStockDetailsBloc();
      stocks = StockDetails().stocks;
    });

    setUpAll(() {
      setupServiceLocator();
    });

    tearDown(() {
      viewStockDetailsBloc.close();
    });

    test('initial state is loading', () {
      expect(viewStockDetailsBloc.state, ViewStockDetailsLoading());
    });

    blocTest(
      'should emit loading and loaded',
      build: () => viewStockDetailsBloc,
      act: (bloc) => bloc.add(FetchStocksEvent()),
      expect: [
        ViewStockDetailsLoading(),
        ViewStockDetailsLoaded(stocks),
      ],
    );

    blocTest(
      'should emit loading and error',
      build: () => viewStockDetailsBloc,
      act: (bloc) => bloc.add(FetchStocksEventByPName("asdfjasdf")),
      expect: [
        ViewStockDetailsError(""),
      ],
    );

    [
      SortStockByPName(),
      SortStockByLStock(),
      SortStockByRStock(),
      SortStockByTStock(),
      SortStockByPName(),
    ].forEach((obj) {
      blocTest(
        'should emit loaded and sorted $obj',
        build: () => viewStockDetailsBloc,
        act: (bloc) {
          return bloc.add(obj);
        },
        verify: (_) {
          if (obj is SortStockByPName) {
            expect(viewStockDetailsBloc.sortByPName, sorting.descending);
          }
          if (obj is SortStockByLStock) {
            expect(viewStockDetailsBloc.sortByLStock, sorting.descending);
          }
          if (obj is SortStockByRStock) {
            expect(viewStockDetailsBloc.sortByRStock, sorting.descending);
          }
          if (obj is SortStockByTStock) {
            expect(viewStockDetailsBloc.sortByTStock, sorting.descending);
          }
        },
        expect: [
          ViewStockDetailsLoaded(stocks),
        ],
      );
    });

    blocTest(
      'should emit  loaded when searching',
      build: () => viewStockDetailsBloc,
      act: (bloc) => bloc.add(FetchStocksEventByPName("Hallow Bloc 12\"")),
      expect: [
        ViewStockDetailsLoaded(stocks),
      ],
    );
  });
}
