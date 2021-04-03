import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("fetch production data", () {
    ViewProductionBloc viewProductionBloc;
    List<Production> productions;

    setUp(() {
      viewProductionBloc = ViewProductionBloc();
      productions = Productions().productions;
    });

    setUpAll(() {
      setupServiceLocator();
    });

    tearDown(() {
      viewProductionBloc.close();
    });

    test("initial state is loading", () {
      expect(viewProductionBloc.state, ViewProductionLoadingState());
    });

    blocTest("emit[loading, success] when fetching",
        build: () => viewProductionBloc,
        act: (bloc) => bloc.add(FetchProductionEvent()),
        expect: [
          ViewProductionLoadingState(),
          ViewProductionLoadedState(productions),
        ]);

    blocTest("emit[loading, success] when fetching",
        build: () => viewProductionBloc,
        act: (bloc) => bloc.add(SearchAndFetchProductionEvent(ename: "kavin")),
        expect: [
          ViewProductionLoadingState(),
          ViewProductionLoadedState(productions),
        ]);

    blocTest("emit[loading, error] when fetching",
        build: () => viewProductionBloc,
        act: (bloc) =>
            bloc.add(SearchAndFetchProductionEvent(ename: "kavasdfin")),
        expect: [
          ViewProductionLoadingState(),
          ViewProductionErrorState("message"),
        ]);

    blocTest("sort by date ",
        build: () => viewProductionBloc,
        act: (bloc) => bloc.add(SortProductionByDate()),
        verify: (f) {
          expect(viewProductionBloc.sortProductionByDate, sorting.descending);
        },
        expect: [
          ViewProductionLoadedState(productions),
        ]);
  });
}
