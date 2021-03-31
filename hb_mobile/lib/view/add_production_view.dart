import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/build_mp_entry_fields.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/build_production_entry_fields.dart';

class AddProductionScreen extends StatelessWidget {
  static const String _title = 'Production Entry';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AddProductionScreen._title)),
      body: MultiBlocProvider(
        child: AddProductionForm(),
        providers: [
          BlocProvider(
            create: (BuildContext context) => ProductionPrerequisiteBloc(),
          ),
          BlocProvider(create: (BuildContext context) => ProductionEntryBloc()),
        ],
      ),
    );
  }
}

class AddProductionForm extends StatefulWidget {
  @override
  _AddProductionFormState createState() => _AddProductionFormState();
}

class _AddProductionFormState extends State<AddProductionForm> {
  ProductionPrerequisiteBloc _productionPrerequisiteBloc;

  @override
  void initState() {
    _productionPrerequisiteBloc =
        BlocProvider.of<ProductionPrerequisiteBloc>(context)
          ..add(GetProductionPrerequisite());
    super.initState();
  }

  @override
  void dispose() {
    _productionPrerequisiteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductionPrerequisiteBloc, ProductionPrerequisiteState>(
      builder: (BuildContext context, state) {
        if (state is ProductionPrerequisiteLoaded) {
          return _buildFields(state);
          // return _buildFields(context, state.suppliers, state.material);
        }
        if (state is ProductionPrerequisiteLoading) {
          return LinearProgressIndicator();
        }
        if (state is ProductionPrerequisiteError) {
          return Text("${state.message}");
        } else {
          return Text('unknown state error please report to developer');
        }
      },
    );
  }

  Widget _buildFields(ProductionPrerequisiteLoaded state) {
    return BlocListener<ProductionEntryBloc, ProductionEntryState>(
      listener: (BuildContext context, state) async {
        if (state is ProductionEntryError) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              warningSnackBar(message: state.message),
            );
        }
        if (state is ProductionEntryLoading) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              progressSnackBar(
                  message: state.message,
                  seconds: 1,
                  child: CircularProgressIndicator()),
            );
        }
        if (state is ProductionEntryError) {
          await Future.delayed(Duration(milliseconds: 500));
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              warningSnackBar(message: state.message),
            );

          // _billNoController.clear();
          // _customerCodeController.clear();
        }
        if (state is ProductionEntrySuccess) {
          await Future.delayed(Duration(seconds: 1));
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(progressSnackBar(message: state.message));
          await Future.delayed(Duration(milliseconds: 2500));
          // Navigator.pushNamed(context, kExistingProduction);
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => TotalPriceCubit(0)),
          BlocProvider(
              create: (BuildContext context) => DatePickerCubit("Select Date")),
          BlocProvider(
              create: (BuildContext context) =>
                  ProductionWorkerCubit(ProductionWorker("0", "0"))),
          BlocProvider(
            create: (BuildContext context) =>
                RandomCodeCubit("Production code"),
          ),
          // BlocProvider(
          //   create: (BuildContext context) => MPBloc(),
          // ),
        ],
        child: BuildProductionEntryFields(
          products: state.products,
          employees: state.employee,
        ),
      ),
    );
    // return MultiBlocProvider(
    //   providers: [
    //     BlocProvider(create: (BuildContext context) => TotalPriceCubit(0)),
    //     BlocProvider(
    //         create: (BuildContext context) => DatePickerCubit("Select Date")),
    //     // BlocProvider(
    //     //   create: (BuildContext context) => MPBloc(),
    //     // ),
    //   ],
    //   child: BuildEntryFields(
    //     suppliers: state.suppliers,
    //     materials: state.material,
    //   ),
    // );
  }
}
