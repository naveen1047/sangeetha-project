import 'package:bloc_test/bloc_test.dart';
import 'package:core/src/business_logics/bloc/view_stock_details_bloc/view_stock_details_bloc.dart';
import 'package:core/src/business_logics/models/stock_details.dart';
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
      'should emit  loaded when searching',
      build: () => viewStockDetailsBloc,
      act: (bloc) => bloc.add(FetchStocksEventByPName("Hallow Bloc 12\"")),
      expect: [
        ViewStockDetailsLoaded(stocks),
      ],
    );
  });
}
