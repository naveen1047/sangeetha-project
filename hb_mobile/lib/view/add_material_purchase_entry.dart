import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:core/core.dart';

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
            create: (BuildContext context) => MaterialPurchaseBloc(),
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
  MaterialPurchaseBloc _materialPurchaseBloc;
  TextEditingController _dateController;

  @override
  void initState() {
    _materialPurchaseBloc = BlocProvider.of<MaterialPurchaseBloc>(context)
      ..add(FetchPrerequisite(selectedDate));
    _dateController = TextEditingController();
    _dateController.text = selectedDate.toString();
    super.initState();
  }

  @override
  void dispose() {
    _materialPurchaseBloc.close();
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
    return BlocBuilder<MaterialPurchaseBloc, MaterialPurchaseState>(
      builder: (BuildContext context, state) {
        if (state is PrerequisiteLoaded) {
          return _buildFields(context, state.suppliers);
        }
        if (state is PrerequisiteLoading) {
          return LinearProgressIndicator();
        }
        if (state is PrerequisiteError) {
          return Text("${state.message}");
        } else {
          return Text('unknown state error please report to developer');
        }
      },
    );
  }

  ListView _buildFields(
      BuildContext context, List<SupplierNameCode> supplierNameCodes) {
    return ListView(
      children: [
        InputField(
          child: FlatButton(
            minWidth: double.maxFinite,
            onPressed: () {
              return _selectDate(context);
            },
            child: BlocBuilder<MaterialPurchaseBloc, MaterialPurchaseState>(
              builder: (BuildContext context, state) {
                if (state is PrerequisiteLoaded) {
                  return Text(state.date);
                } else {
                  return Text("No state returned");
                }
              },
            ),
          ),
          iconData: Icons.date_range,
        ),
        MyStatefulWidget(
          suppliers: supplierNameCodes,
        )
      ],
    );
  }
}

//
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key, this.suppliers}) : super(key: key);
  final List<SupplierNameCode> suppliers;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState(
      suppliers, suppliers.first.sname, suppliers.single.scode);
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<SupplierNameCode> suppliers;

  _MyStatefulWidgetState(
      List<SupplierNameCode> suppliers, String scode, String sname) {
    this.firstValue = scode + "-" + sname;
    this.suppliers = suppliers;
  }

  String firstValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: firstValue,
      onChanged: (String newValue) {
        setState(() {
          print(newValue);
          firstValue = newValue.toString();
        });
      },
      // items: <String>['One', 'Two', 'Free', 'Four']
      //     .map<DropdownMenuItem<String>>((String value) {
      //   return DropdownMenuItem<String>(
      //     value: value,
      //     child: Text(value),
      //   );
      // }).toList(),
      items: widget.suppliers
          .map<DropdownMenuItem<String>>((SupplierNameCode value) {
        return DropdownMenuItem<String>(
          value: value.sname,
          child: Text(value.sname),
        );
      }).toList(),
    );
  }
}
