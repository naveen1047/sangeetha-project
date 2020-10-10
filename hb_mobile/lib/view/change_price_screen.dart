import 'package:core/core.dart';
import 'package:core/src/business_logics/bloc/material_bloc.dart'
    as materialBloc;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class ChangePriceScreen extends StatelessWidget {
  final String title;

  const ChangePriceScreen({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ChangePriceForm(),
    );
  }
}

class ChangePriceForm extends StatefulWidget {
  @override
  _ChangePriceFormState createState() => _ChangePriceFormState();
}

class _ChangePriceFormState extends State<ChangePriceForm> {
  TextEditingController _unitController;

  @override
  void initState() {
    _unitController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPrimaryPadding,
      child: ListView(
        children: [
          MaterialDropdown(),
          InputField(
            textField: TextField(
              controller: _unitController,
              onChanged: (text) {
                context.bloc<RandomCodeCubit>().generate(text);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'price per unit',
              ),
            ),
            iconData: Icons.attach_money,
          ),
          Text(
            'Per 10',
            textAlign: TextAlign.right,
          ),
          Padding(
            padding: kTopPadding,
            child: PrimaryActionButton(
              title: 'Change',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class MaterialDropdown extends StatefulWidget {
  @override
  _MaterialDropdownState createState() => _MaterialDropdownState();
}

class _MaterialDropdownState extends State<MaterialDropdown> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: kTextColor),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
