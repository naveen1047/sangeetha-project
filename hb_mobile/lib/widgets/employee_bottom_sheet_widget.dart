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
            listener: (context, state) async {
              if (state is EmployeeSuccess) {
                await Future.delayed(Duration(seconds: 1));
                widget.viewEmployeeBloc.add(FetchEmployeeEvent());
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeSuccess) {
                  return message("Value changed successfully");
                }
                if (state is EmployeeLoading) {
                  return message(
                    "Updating...",
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is EmployeeError) {
                  return _errorMessage(state);
                } else {
                  return _title();
                }
              },
            ),
          ),
          _date(),
          _code(),
          _name(),
          _contact(),
          _address(),
          // _buildCodeField(),
          // _buildCalender(),
          // _buildNameField(),
          // _buildContactField(),
          // _buildAddressField(),
          _buildActionButton(context)
        ],
      ),
    );
  }

  Widget _date() {
    return TextFormField(
      enabled: false,
      controller: _addDateController,
      decoration: InputDecoration(
        icon: Icon(Icons.date_range),
        labelText: 'Date',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  TextFormField _address() {
    return TextFormField(
      maxLength: 250,
      minLines: 1,
      maxLines: 2,
      controller: _addressController,
      decoration: InputDecoration(
        icon: Icon(Icons.home),
        labelText: 'Address',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  TextFormField _contact() {
    return TextFormField(
      maxLength: 13,
      controller: _contactController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        icon: Icon(Icons.call),
        labelText: 'Contact',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  Widget _code() {
    return TextFormField(
      enabled: false,
      controller: _employeeCodeController,
      decoration: InputDecoration(
        icon: Icon(Icons.info),
        labelText: 'Employee code',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  TextFormField _name() {
    return TextFormField(
      controller: _employeeNameController,
      maxLength: 28,
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Employee Name',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  Padding _title() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('Edit Employee'),
    );
  }

  Padding _buildActionButton(BuildContext context) {
    return Padding(
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
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Padding _errorMessage(EmployeeError state) {
    return Padding(
      padding: kPrimaryPadding,
      child: Text(
        '${state.message}',
        style: TextStyle(
          color: Colors.red,
        ),
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
