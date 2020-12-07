import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/build_mp_entry_fields.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

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
          BlocProvider(
            create: (BuildContext context) => MPBloc(),
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
          return _buildFields(state);
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

  Widget _buildFields(MPPrerequisiteLoaded state) {
    return BlocListener<MPBloc, MPState>(
      listener: (BuildContext context, state) async {
        if (state is MPError) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              warningSnackBar(message: state.message),
            );
        }
        if (state is MPLoading) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              progressSnackBar(
                  message: state.message,
                  seconds: 1,
                  child: CircularProgressIndicator()),
            );
        }
        if (state is MPErrorAndClear) {
          await Future.delayed(Duration(milliseconds: 500));
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              warningSnackBar(message: state.message),
            );

          // _billNoController.clear();
          // _customerCodeController.clear();
        }
        if (state is MPSuccess) {
          await Future.delayed(Duration(seconds: 1));
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(progressSnackBar(message: state.message));
          await Future.delayed(Duration(milliseconds: 2500));
          Navigator.pushNamed(context, kExistingMaterialPurchase);
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => TotalPriceCubit(0)),
          BlocProvider(
              create: (BuildContext context) => DatePickerCubit("Select Date")),
          // BlocProvider(
          //   create: (BuildContext context) => MPBloc(),
          // ),
        ],
        child: BuildEntryFields(
          suppliers: state.suppliers,
          materials: state.material,
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
