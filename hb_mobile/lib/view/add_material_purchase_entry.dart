import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:core/core.dart';
import 'package:core/src/business_logics/models/material.dart' as m;

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
  TextEditingController _dateController;

  @override
  void initState() {
    _mpPrerequisiteBloc = BlocProvider.of<MPPrerequisiteBloc>(context)
      ..add(GetMPPrerequisite());
    _dateController = TextEditingController();
    _dateController.text = selectedDate.toString();
    super.initState();
  }

  @override
  void dispose() {
    _mpPrerequisiteBloc.close();
    _dateController.dispose();
    super.dispose();
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        context
            .bloc<MaterialPurchaseBloc>()
            .add(FetchPrerequisite(selectedDate));
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MPPrerequisiteBloc, MPPrerequisiteState>(
      builder: (BuildContext context, state) {
        if (state is MPPrerequisiteLoaded) {
          return BuildEntryFields(
            suppliers: state.suppliers,
            materials: state.material,
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

  ListView _buildFields(BuildContext context,
      List<SupplierNameCode> supplierNameCodes, List<m.Material> materials) {
    return ListView(
      children: [
        // InputField(
        //   child: FlatButton(
        //     minWidth: double.maxFinite,
        //     onPressed: () {
        //       return _selectDate(context);
        //     },
        //     child: BlocBuilder<MaterialPurchaseBloc, MaterialPurchaseState>(
        //       builder: (BuildContext context, state) {
        //         if (state is PrerequisiteLoaded) {
        //           return Text(state.date);
        //         } else {
        //           return Text("No state returned");
        //         }
        //       },
        //     ),
        //   ),
        //   iconData: Icons.date_range,
        // ),
      ],
    );
  }
}

class BuildEntryFields extends StatefulWidget {
  final List<SupplierNameCode> suppliers;
  final List<m.Material> materials;

  const BuildEntryFields({Key key, this.suppliers, this.materials})
      : super(key: key);

  @override
  _BuildEntryFieldsState createState() =>
      _BuildEntryFieldsState(suppliers, materials);
}

class _BuildEntryFieldsState extends State<BuildEntryFields> {
  List<SupplierNameCode> suppliers;
  List<m.Material> materials;

  _BuildEntryFieldsState(
      List<SupplierNameCode> suppliers, List<m.Material> materials) {
    this.suppliers = suppliers;
    this.materials = materials;
  }

  String selectedSupplier;
  String selectedMaterial;

  @override
  void initState() {
    selectedSupplier = suppliers[0].scode;
    selectedMaterial = materials[0].mcode;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Text("Select Supplier"),
            value: selectedSupplier,
            onChanged: (String newValue) {
              setState(() {
                selectedSupplier = newValue;
              });
              print(selectedSupplier);
            },
            items: suppliers.map((SupplierNameCode s) {
              return DropdownMenuItem<String>(
                value: s.scode,
                child: Text(s.sname),
              );
            }).toList(),
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Text("Select Material"),
            value: selectedMaterial,
            onChanged: (String newValue) {
              setState(() {
                selectedMaterial = newValue;
              });
              print(selectedMaterial);
            },
            items: materials.map((m.Material m) {
              return DropdownMenuItem<String>(
                value: m.mcode,
                child: Text(m.mname),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
