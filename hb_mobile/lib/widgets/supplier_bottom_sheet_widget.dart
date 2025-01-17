import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';

import 'common_widgets.dart';

class SupplierBottomSheet extends StatefulWidget {
  final viewSupplierBloc;
  final String supplierCode;
  final String supplierName;
  final String supplierContact;
  final String supplierAddress;

  const SupplierBottomSheet({
    Key key,
    @required this.supplierCode,
    @required this.supplierName,
    @required this.supplierContact,
    @required this.supplierAddress,
    this.viewSupplierBloc,
  }) : super(key: key);

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<SupplierBottomSheet> {
  SupplierBloc _addSupplierBloc;
  TextEditingController _supplierNameController;
  TextEditingController _supplierCodeController;
  TextEditingController _contactController;
  TextEditingController _addressController;
  TextEditingController _addDateController;

  @override
  void initState() {
    _addSupplierBloc = BlocProvider.of<SupplierBloc>(context);
    _supplierNameController = TextEditingController();
    _supplierCodeController = TextEditingController();
    _contactController = TextEditingController();
    _addressController = TextEditingController();
    _addDateController = TextEditingController();
    setValues();
    super.initState();
  }

  void setValues() {
    _supplierCodeController.text = widget.supplierCode;
    _supplierNameController.text = widget.supplierName;
    _contactController.text = widget.supplierContact;
    _addressController.text = widget.supplierAddress;
    _addDateController.text = _addSupplierBloc.getDateInFormat;
  }

  @override
  void dispose() {
    _supplierNameController.dispose();
    _supplierCodeController.dispose();
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
          BlocListener<SupplierBloc, SupplierState>(
            listener: (context, state) async {
              if (state is SupplierSuccess) {
                await Future.delayed(Duration(seconds: 1));
                widget.viewSupplierBloc.add(FetchSupplierEvent());
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<SupplierBloc, SupplierState>(
              builder: (context, state) {
                if (state is SupplierSuccess) {
                  return message("Value changed successfully");
                }
                if (state is SupplierLoading) {
                  return message(
                    "Updating...",
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is SupplierError) {
                  return _errorMessage(state);
                } else {
                  return _title();
                }
              },
            ),
          ),
          _name(),
          _code(context),
          _contact(),
          _address(),
          _date(),
          _buildActionButtons(context),
          // _buildCodeField(),
          // _buildDateField(),
          // _buildNameField(),
          // _buildContactField(),
          // _buildAddressField(),
          // _buildActionButtons(context),
        ],
      ),
    );
  }

  Padding _buildActionButtons(BuildContext context) {
    return Padding(
      padding: kPrimaryPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PrimaryActionButton(
            // color: Theme.of(context).primaryColor,
            title: 'Change',
            onPressed: () {
              uploadData();
            },
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
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
      keyboardType: TextInputType.multiline,
      controller: _addressController,
      maxLength: 250,
      minLines: 1,
      maxLines: 2,
      decoration: InputDecoration(
        icon: Icon(Icons.home),
        labelText: 'Address',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  TextFormField _contact() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _contactController,
      maxLength: 15,
      decoration: InputDecoration(
        icon: Icon(Icons.call),
        labelText: 'Contact',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  Widget _code(BuildContext context) {
    return TextFormField(
      enabled: false,
      controller: _supplierCodeController,
      decoration: InputDecoration(
        icon: Icon(Icons.info),
        labelText: 'Supplier code',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  TextFormField _name() {
    return TextFormField(
      controller: _supplierNameController,
      maxLength: 35,
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Supplier Name',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  void uploadData() {
    _addSupplierBloc
      ..add(
        EditSupplier(
          sname: _supplierNameController.text,
          saddate: _addDateController.text,
          saddress: _addressController.text,
          scode: _supplierCodeController.text,
          snum: _contactController.text,
        ),
      );
  }

  Padding _title() {
    return Padding(
      padding: kPrimaryPadding,
      child: Text(
        'Edit Supplier',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }

  Padding _errorMessage(SupplierError state) {
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
}
