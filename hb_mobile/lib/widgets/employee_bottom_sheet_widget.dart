
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';

import 'common_widgets.dart';

class EmployeeBottomSheet extends StatefulWidget {
  final viewEmployeeBloc;
  final String employeecode;
  final String employeeName;
  final String employeeContact;
  final String employeeAddress;

  const EmployeeBottomSheet({
    Key key,
    @required this.employeecode,
    @required this.employeeName,
    @required this.employeeContact,
    @required this.employeeAddress,
    this.viewEmployeeBloc,
  }) : super(key: key);

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<EmployeeBottomSheet> {
  EmployeeBloc _addEmployeeBloc;
  TextEditingController _employeeNameController;
  TextEditingController _employeeCodeController;
  TextEditingController _contactController;
  TextEditingController _addressController;
  TextEditingController _addDateController;

  @override
  void initState() {
    _addEmployeeBloc = BlocProvider.of<EmployeeBloc>(context);
    _employeeNameController = TextEditingController();
    _employeeCodeController = TextEditingController();
    _contactController = TextEditingController();
    _addressController = TextEditingController();
    _addDateController = TextEditingController();
    setValues();
    super.initState();
  }

  void setValues() {
    _employeeCodeController.text = widget.employeecode;
    _employeeNameController.text = widget.employeeName;
    _contactController.text = widget.employeeContact;
    _addressController.text = widget.employeeAddress;
    _addDateController.text = _addEmployeeBloc.getDateInFormat;
  }

  @override
  void dispose() {
    _employeeNameController.dispose();
    _employeeCodeController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _addDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPrimaryPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BlocListener<EmployeeBloc, EmployeeState>(
            listener: (context, state) {
              if (state is EmployeeSuccess) {
                widget.viewEmployeeBloc.add(FetchEmployeeEvent());
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${state.message}',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Edit Employee'),
                  );
                }
              },
            ),
          ),
          InputField(
            child: TextField(
              enabled: false,
              controller: _employeeCodeController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Employee code',
              ),
            ),
            iconData: Icons.info,
            isDisabled: true,
          ),
          InputField(
            child: TextField(
              enabled: false,
              controller: _addDateController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Date',
              ),
            ),
            iconData: Icons.calendar_today,
            isDisabled: true,
          ),
          InputField(
            child: TextField(
              controller: _employeeNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Name',
              ),
            ),
            iconData: Icons.person,
          ),
          InputField(
            child: TextField(
              controller: _contactController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Contact',
              ),
            ),
            iconData: Icons.call,
          ),
          InputField(
            child: TextField(
              minLines: 1,
              maxLines: 2,
              controller: _addressController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Address',
              ),
            ),
            iconData: Icons.home,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PrimaryActionButton(
                  title: 'Change',
                  onPressed: () {
                    uploadData();
                  },
                ),
                RaisedButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void uploadData() {
    _addEmployeeBloc
      ..add(
        EditEmployee(
          ename: _employeeNameController.text,
          eaddate: _addDateController.text,
          eaddress: _addressController.text,
          ecode: _employeeCodeController.text,
          enumber: _contactController.text,
        ),
      );
  }
}
