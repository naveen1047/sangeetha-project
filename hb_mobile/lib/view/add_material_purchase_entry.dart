import 'package:flutter/material.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class AddMaterialPurchaseScreen extends StatefulWidget {
  static const String _title = 'Material Purchase Entry';

  @override
  _AddMaterialPurchaseScreenState createState() =>
      _AddMaterialPurchaseScreenState();
}

class _AddMaterialPurchaseScreenState extends State<AddMaterialPurchaseScreen> {
  TextEditingController _dateController;

  @override
  void initState() {
    _dateController = TextEditingController();
    _dateController.text = selectedDate.toString();
    super.initState();
  }

  @override
  void dispose() {
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
    return Scaffold(
      appBar: AppBar(title: const Text(AddMaterialPurchaseScreen._title)),
      body: ListView(
        children: [
          InputField(
            child: FlatButton(
              minWidth: double.maxFinite,
              onPressed: () => _selectDate(context),
              child: Text(generateDate()),
            ),
            iconData: Icons.date_range,
          ),
        ],
      ),
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
