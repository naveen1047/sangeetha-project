import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:hb_mobile/widgets/BuildMPEntryFields.dart';

class AddMaterialPurchaseScreen extends StatelessWidget {
  static const String _title = 'Material Purchase Entry';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AddMaterialPurchaseScreen._title)),
      body: MultiBlocProvider(
        child: AddMaterialPurchaseForm(),
        providers: [
          BlocProvider(
            create: (BuildContext context) => MPPrerequisiteBloc(),
          ),
        ],
      ),
    );
  }
}

class AddMaterialPurchaseForm extends StatefulWidget {
  @override
  _AddMaterialPurchaseFormState createState() =>
      _AddMaterialPurchaseFormState();
}

class _AddMaterialPurchaseFormState extends State<AddMaterialPurchaseForm> {
  MPPrerequisiteBloc _mpPrerequisiteBloc;

  @override
  void initState() {
    _mpPrerequisiteBloc = BlocProvider.of<MPPrerequisiteBloc>(context)
      ..add(GetMPPrerequisite());
    super.initState();
  }

  @override
  void dispose() {
    _mpPrerequisiteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MPPrerequisiteBloc, MPPrerequisiteState>(
      builder: (BuildContext context, state) {
        if (state is MPPrerequisiteLoaded) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (BuildContext context) => TotalPriceCubit(0)),
              BlocProvider(
                  create: (BuildContext context) =>
                      DatePickerCubit("Select Date")),
            ],
            child: BuildEntryFields(
              suppliers: state.suppliers,
              materials: state.material,
            ),
          );
          // return _buildFields(context, state.suppliers, state.material);
        }
        if (state is MPPrerequisiteLoading) {
          return LinearProgressIndicator();
        }
        if (state is MPPrerequisiteError) {
          return Text("${state.message}");
        } else {
          return Text('unknown state error please report to developer');
        }
      },
    );
  }
}
