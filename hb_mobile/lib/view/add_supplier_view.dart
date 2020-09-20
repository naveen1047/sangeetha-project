import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class AddSuppliersScreen extends StatelessWidget {
  final String title;

  const AddSuppliersScreen({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => SupplierBloc(),
          ),
          BlocProvider(
            create: (BuildContext context) => ScodeCubit("Supplier code"),
          ),
        ],
        child: AddSupplierForm(),
      ),
    );
  }
}

class AddSupplierForm extends StatefulWidget {
  @override
  _AddSupplierFormState createState() => _AddSupplierFormState();
}

class _AddSupplierFormState extends State<AddSupplierForm> {
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
    setDate();
    super.initState();
  }

  void setDate() {
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
    return BlocListener<SupplierBloc, SupplierState>(
      listener: (BuildContext context, state) {
        if (state is SupplierError) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  '${state.message}',
                  softWrap: true,
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state is SupplierSuccess) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  '${state.message}',
                  softWrap: true,
                ),
              ),
            );
        }
      },
      child: Padding(
        padding: kPrimaryPadding,
        child: ListView(
          children: [
            InputField(
              textField: TextField(
                controller: _supplierNameController,
                onChanged: (text) {
                  context.bloc<ScodeCubit>().generate(text);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Supplier Name',
                ),
              ),
              iconData: Icons.person,
            ),
            BlocBuilder<ScodeCubit, String>(builder: (context, state) {
              _supplierCodeController.text = '$state';
              return InputField(
                textField: TextField(
                  enabled: false,
                  controller: _supplierCodeController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Supplier code',
                  ),
                ),
                iconData: Icons.info,
                isDisabled: true,
              );
            }),
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
                enabled: false,
                controller: _addDateController,
                decoration: InputDecoration(
                  border: InputBorder.none,
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
                  uploadData();
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

  void uploadData() {
    _addSupplierBloc.add(
      AddSupplier(
        sname: _supplierNameController.text,
        saddate: _addDateController.text,
        saddress: _addressController.text,
        scode: _supplierCodeController.text,
        snum: _contactController.text,
      ),
    );
  }
}
