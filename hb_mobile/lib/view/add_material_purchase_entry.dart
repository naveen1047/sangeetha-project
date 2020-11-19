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
      ..add(SetDate());
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
            .add(SetDate(dateTime: selectedDate));
      });
  }

  String generateDate() {
    String day =
        selectedDate.day < 10 ? '0${selectedDate.day}' : '${selectedDate.day}';
    String month = selectedDate.month < 10
        ? '0${selectedDate.month}'
        : '${selectedDate.month}';
    int year = selectedDate.year;
    return '$day-$month-$year';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        InputField(
          child: FlatButton(
            minWidth: double.maxFinite,
            onPressed: () {
              _selectDate(context);
            },
            child: BlocBuilder<MaterialPurchaseBloc, MaterialPurchaseState>(
              builder: (BuildContext context, state) {
                if (state is GetDate) {
                  return Text(state.date);
                } else {
                  return Text("asdf");
                }
              },
            ),
          ),
          iconData: Icons.date_range,
        ),
      ],
    );
  }
}

//
// class MyStatefulWidget extends StatefulWidget {
//   MyStatefulWidget({Key key}) : super(key: key);
//
//   @override
//   _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
// }
//
// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   String dropdownValue = 'One';
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       value: dropdownValue,
//       icon: Icon(Icons.arrow_downward),
//       onChanged: (String newValue) {
//         setState(() {
//           dropdownValue = newValue;
//           print("${dropdownValue}");
//         });
//       },
//       items: <String>['One', 'Two', 'Free', 'Four']
//           .map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }
