import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';

import 'common_widgets.dart';

class CustomerBottomSheet extends StatefulWidget {
  final viewCustomerBloc;
  final String customerCode;
  final String customerName;
  final String customerContact;
  final String customerAddress;

  const CustomerBottomSheet({
    Key key,
    @required this.customerCode,
    @required this.customerName,
    @required this.customerContact,
    @required this.customerAddress,
    this.viewCustomerBloc,
  }) : super(key: key);

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<CustomerBottomSheet> {
  CustomerBloc _addCustomerBloc;
  TextEditingController _customerNameController;
  TextEditingController _customerCodeController;
  TextEditingController _contactController;
  TextEditingController _addressController;
  TextEditingController _addDateController;

  @override
  void initState() {
    _addCustomerBloc = BlocProvider.of<CustomerBloc>(context);
    _customerNameController = TextEditingController();
    _customerCodeController = TextEditingController();
    _contactController = TextEditingController();
    _addressController = TextEditingController();
    _addDateController = TextEditingController();
    setValues();
    super.initState();
  }

  void setValues() {
    _customerCodeController.text = widget.customerCode;
    _customerNameController.text = widget.customerName;
    _contactController.text = widget.customerContact;
    _addressController.text = widget.customerAddress;
    _addDateController.text = _addCustomerBloc.getDateInFormat;
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerCodeController.dispose();
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
          BlocListener<CustomerBloc, CustomerState>(
            listener: (context, state) async {
              if (state is CustomerSuccess) {
                await Future.delayed(Duration(seconds: 1));
                widget.viewCustomerBloc.add(FetchCustomerEvent());
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                if (state is CustomerSuccess) {
                  return message("Value changed successfully");
                }
                if (state is CustomerLoading) {
                  return message(
                    "Updating...",
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is CustomerError) {
                  return _errorMessage(state);
                } else {
                  return _title();
                }
              },
            ),
          ),
          _buildCodeField(),
          _buildDateField(),
          _buildNameField(),
          _buildContactField(),
          _buildAddressField(),
          _buildActionButtons(context),
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
            color: Theme.of(context).primaryColor,
            title: 'Change',
            onPressed: () {
              uploadData();
            },
          ),
          RaisedButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void uploadData() {
    _addCustomerBloc
      ..add(
        EditCustomer(
          cname: _customerNameController.text,
          caddate: _addDateController.text,
          caddress: _addressController.text,
          ccode: _customerCodeController.text,
          cnum: _contactController.text,
        ),
      );
  }

  InputField _buildAddressField() {
    return InputField(
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
    );
  }

  InputField _buildContactField() {
    return InputField(
      child: TextField(
        controller: _contactController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Contact',
        ),
      ),
      iconData: Icons.call,
    );
  }

  InputField _buildNameField() {
    return InputField(
      child: TextField(
        controller: _customerNameController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Name',
        ),
      ),
      iconData: Icons.person,
    );
  }

  InputField _buildDateField() {
    return InputField(
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
    );
  }

  InputField _buildCodeField() {
    return InputField(
      child: TextField(
        enabled: false,
        controller: _customerCodeController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Customer code',
        ),
      ),
      iconData: Icons.info,
      isDisabled: true,
    );
  }

  Padding _title() {
    return Padding(
      padding: kPrimaryPadding,
      child: Text(
        'Edit Customer',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }

  Padding _errorMessage(CustomerError state) {
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
