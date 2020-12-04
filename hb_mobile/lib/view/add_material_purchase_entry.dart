import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:core/core.dart';
import 'package:core/src/business_logics/models/material.dart' as m;

import '../constant.dart';

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
  TextEditingController _billNoController;
  TextEditingController _quantityController;
  TextEditingController _unitPriceController;
  TextEditingController _totalPriceController;
  TextEditingController _remarksController;
  TextEditingController _dateController;

  _BuildEntryFieldsState(
      List<SupplierNameCode> suppliers, List<m.Material> materials) {
    this.suppliers = suppliers;
    this.materials = materials;
  }

  String selectedSupplier;
  String selectedMaterial;
  bool isDisabled = true;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    selectedSupplier = suppliers[0].scode;
    selectedMaterial = materials[0].mcode;

    _billNoController = TextEditingController();
    _quantityController = TextEditingController();
    _unitPriceController = TextEditingController();
    _totalPriceController = TextEditingController();
    _remarksController = TextEditingController();
    _dateController = TextEditingController();
    _dateController.text = selectedDate.toString();

    _unitPriceController.text = materials[0].mpriceperunit;

    super.initState();
  }

  @override
  void dispose() {
    _billNoController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _totalPriceController.dispose();
    _remarksController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        context.bloc<DatePickerCubit>().selectDate(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPrimaryPadding,
      child: ListView(
        children: [
          InputField(
            child: FlatButton(
              minWidth: double.maxFinite,
              onPressed: () {
                return _selectDate(context);
              },
              child: BlocBuilder<DatePickerCubit, String>(
                builder: (BuildContext context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Text(state),
                      Icon(Icons.edit, color: kActionIconColor),
                    ],
                  );
                },
              ),
            ),
            iconData: Icons.date_range,
          ),
          DropdownButtonHideUnderline(
            child: DropdownDecorator(
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
          ),
          InputField(
            child: TextField(
              maxLength: 28,
              controller: _billNoController,
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                hintText: 'Bill No',
              ),
            ),
            iconData: Icons.notes,
          ),
          DropdownButtonHideUnderline(
            child: DropdownDecorator(
              child: DropdownButton<String>(
                hint: Text("Select Material"),
                value: selectedMaterial,
                onChanged: (String newValue) {
                  setState(() {
                    selectedMaterial = newValue;
                    var material = materials
                        .where((element) => element.mcode == selectedMaterial);
                    _unitPriceController.text =
                        material.first.mpriceperunit.toString();
                    context
                        .bloc<TotalPriceCubit>()
                        .setPrice(double.parse(material.first.mpriceperunit));
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
          ),
          InputField(
            isDisabled: isDisabled,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _unitPriceController,
              enabled: !isDisabled,
              onChanged: (text) {
                double p;
                print("a");
                if (text != null && text != "") {
                  p = double.parse(text);
                } else {
                  p = 0.0;
                }
                context.bloc<TotalPriceCubit>().setPrice(p);
              },
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                hintText: 'Unit Price',
              ),
            ),
            iconData: Icons.attach_money_sharp,
            trailing: Container(
              decoration: kOutBdrDisabledDecoration,
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: kActionIconColor,
                ),
                onPressed: () {
                  setState(() {
                    isDisabled = !isDisabled;
                  });
                },
              ),
            ),
          ),
          InputField(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _quantityController,
              onChanged: (text) {
                double q;
                if (text != null && text != "") {
                  q = double.parse(text);
                } else {
                  q = 0.0;
                }
                context.bloc<TotalPriceCubit>().setQuantity(q);
              },
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                hintText: 'Quantity',
              ),
            ),
            iconData: Icons.chevron_right,
          ),
          BlocBuilder<TotalPriceCubit, double>(
              builder: (BuildContext context, state) {
            _totalPriceController.text = '$state';
            return InputField(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _totalPriceController,
                decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  hintText: 'Total Price',
                ),
              ),
              iconData: Icons.attach_money_sharp,
            );
          }),
          InputField(
            child: TextField(
              controller: _remarksController,
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                hintText: 'Remarks',
              ),
            ),
            iconData: Icons.report,
          ),
          Padding(
            padding: kTopPadding,
            child: PrimaryActionButton(
              title: 'Upload',
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                uploadData();
              },
            ),
          ),
          FlatButton(
            child: Text('View Materials purchase'),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              // Navigator.pushNamed(context, kExistingMaterialScreen);
            },
          ),
        ],
      ),
    );
  }

  void uploadData() {}
}
