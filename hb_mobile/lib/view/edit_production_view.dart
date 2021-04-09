import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/build_mp_entry_fields.dart';
import 'package:hb_mobile/widgets/build_production_entry_fields.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/navigate_back_widget.dart';

class InheritedEditPrd extends InheritedWidget {
  const InheritedEditPrd({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        assert(child != null),
        super(key: key, child: child);

  final Production data;

  static InheritedEditPrd of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedEditPrd>();
  }

  @override
  bool updateShouldNotify(InheritedEditPrd old) => data != old.data;
}

class EditProductionScreen extends StatelessWidget {
  static const String _title = 'Edit Production';

  @override
  Widget build(BuildContext context) {
    final Production arg = ModalRoute.of(context).settings.arguments;

    return InheritedEditPrd(
      data: arg,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(EditProductionScreen._title),
          leading: NavigateBackButton(),
        ),
        body: MultiBlocProvider(
          child: EditMaterialPurchaseForm(),
          providers: [
            BlocProvider(
              create: (BuildContext context) => ProductionPrerequisiteBloc(),
            ),
            BlocProvider(
              create: (BuildContext context) => ProductionEntryBloc(),
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
  ProductionPrerequisiteBloc _prdPrerequisiteBloc;

  @override
  void initState() {
    _prdPrerequisiteBloc = BlocProvider.of<ProductionPrerequisiteBloc>(context)
      ..add(GetProductionPrerequisite());
    super.initState();
  }

  @override
  void dispose() {
    _prdPrerequisiteBloc.close();
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
        if (state is ProductionEntryErrorAndClear) {
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
          Navigator.maybePop(context, [kExistingProductionScreen, true]);
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
          //   create: (BuildContext context) => PrdBloc(),
          // ),
        ],
        child: BuildProductionEntryFields(
          products: state.products,
          employees: state.employee,
          isEditable: true,
          p: InheritedEditPrd.of(context).data,
        ),
        // child: BuildEntryFields(
        //   suppliers: state.suppliers,
        //   materials: state.material,
        //   isEditable: true,
        //   mp: InheritedEditPrd.of(context).data,
        // ),
      ),
    );
  }
}
