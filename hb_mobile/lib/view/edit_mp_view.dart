import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/build_mp_entry_fields.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/navigate_back_widget.dart';

class InheritedEditMP extends InheritedWidget {
  const InheritedEditMP({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        assert(child != null),
        super(key: key, child: child);

  final MaterialPurchase data;

  static InheritedEditMP of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedEditMP>();
  }

  @override
  bool updateShouldNotify(InheritedEditMP old) => data != old.data;
}

class EditMPScreen extends StatelessWidget {
  static const String _title = 'Edit Material Purchase';

  @override
  Widget build(BuildContext context) {
    final MaterialPurchase arg = ModalRoute.of(context).settings.arguments;

    return InheritedEditMP(
      data: arg,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(EditMPScreen._title),
          leading: NavigateBackButton(),
        ),
        body: MultiBlocProvider(
          child: EditMaterialPurchaseForm(),
          providers: [
            BlocProvider(
              create: (BuildContext context) => MPPrerequisiteBloc(),
            ),
            BlocProvider(
              create: (BuildContext context) => MPBloc(),
            ),
          ],
        ),
      ),
    );
  }
}

class EditMaterialPurchaseForm extends StatefulWidget {
  @override
  _EditMaterialPurchaseFormState createState() =>
      _EditMaterialPurchaseFormState();
}

class _EditMaterialPurchaseFormState extends State<EditMaterialPurchaseForm> {
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
          Navigator.maybePop(context, kExistingMaterialPurchase);
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => TotalPriceCubit(0.0),
          ),
          BlocProvider(
              create: (BuildContext context) => DatePickerCubit("Select Date")),
          // BlocProvider(
          //   create: (BuildContext context) => MPBloc(),
          // ),
        ],
        child: BuildEntryFields(
          suppliers: state.suppliers,
          materials: state.material,
          isEditable: true,
          mp: InheritedEditMP.of(context).data,
        ),
      ),
    );
  }
}
