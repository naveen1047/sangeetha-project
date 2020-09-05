import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class AddSuppliersScreen extends StatefulWidget {
  @override
  _AddSuppliersScreenState createState() => _AddSuppliersScreenState();
}

class _AddSuppliersScreenState extends State<AddSuppliersScreen> {
  TextEditingController _supplierNameController;
  TextEditingController _supplierCodeController;
  TextEditingController _contactController;
  TextEditingController _addressController;
  TextEditingController _addDateController;

  @override
  void initState() {
    _supplierNameController = TextEditingController();
    _supplierCodeController = TextEditingController();
    _contactController = TextEditingController();
    _addressController = TextEditingController();
    _addDateController = TextEditingController();
    super.initState();
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
    final bloc = AddSupplierBloc();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Suppliers'),
      ),
      body: Padding(
        padding: kPrimaryPadding,
        child: ListView(
          children: [
            InputField(
              textField: TextField(
                controller: _supplierNameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Supplier Name',
                ),
              ),
              iconData: Icons.person,
            ),
            InputField(
              textField: TextField(
                controller: _supplierCodeController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Supplier code',
                ),
              ),
              iconData: Icons.info,
              isDisabled: true,
            ),
            InputField(
              textField: TextField(
                controller: _contactController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Contact',
                ),
              ),
              iconData: Icons.call,
            ),
            InputField(
              textField: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Address',
                ),
              ),
              iconData: Icons.home,
            ),
            InputField(
              textField: TextField(
                controller: _addDateController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'current date',
                ),
              ),
              iconData: Icons.date_range,
              isDisabled: true,
            ),
            Padding(
              padding: kTopPadding,
              child: PrimaryActionButton(
                title: 'Upload',
                onPressed: () {
                  bloc.add(
                    AddSupplier(
                      sname: _supplierNameController.text,
                      saddate: _addDateController.text,
                      saddress: _addressController.text,
                      scode: _supplierCodeController.text,
                      snum: _contactController.text,
                    ),
                  );
                },
              ),
            ),
            FlatButton(
              child: Text('View existing suppliers'),
              onPressed: () {
                Navigator.pushNamed(context, kExistingSuppliersScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
