import 'package:bloc_test/bloc_test.dart';
import 'package:core/src/business_logics/bloc/view_material_bloc.dart';
import 'package:core/src/business_logics/models/material.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('View material Bloc test', () {
    ViewMaterialBloc viewMaterialBloc;
    List<Material> materials;

    setUp(() {
      viewMaterialBloc = ViewMaterialBloc();
      materials = Materials().materials;
    });

    setUpAll(() {
      setupServiceLocator();
    });

    tearDown(() {
      viewMaterialBloc.close();
    });

    test(
      'initial state is loading',
      () => expect(viewMaterialBloc.state, MaterialLoadingState()),
      skip: true,
    );

    blocTest(
      'should emit loading and loaded',
      build: () => viewMaterialBloc,
      act: (bloc) => bloc.add(FetchMaterialEvent()),
      expect: [
        MaterialLoadingState(),
        // MaterialLoadedState(materials),
      ],
    );
  });
}
