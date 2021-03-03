import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("fetch production data", () {
    ViewProductBloc viewProductBloc;

    setUp(() {
      viewProductBloc = ViewProductBloc();
    });

    setUpAll(() {
      setupServiceLocator();
    });

    tearDown(() {
      viewProductBloc.close();
    });

    test("initial state is loading", () {
      expect(viewProductBloc.state, ProductLoadingState());
    });

    test("emit[loading, success] when fetching", () {});

    test("emit[loading, error] when error", () {});
  });
}
