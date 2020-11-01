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
            create: (BuildContext context) => RandomCodeCubit("Supplier code"),
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
      listener: (BuildContext context, state) async {
        if (state is SupplierError) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              warningSnackBar(message: state.message),
            );
        }
        if (state is SupplierLoading) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              progressSnackBar(
                  message: state.message,
                  seconds: 1,
                  child: CircularProgressIndicator()),
            );
        }
        if (state is SupplierErrorAndClear) {
          await Future.delayed(Duration(milliseconds: 500));
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              warningSnackBar(message: state.message),
            );

          _supplierNameController.clear();
          _supplierCodeController.clear();
        }
        if (state is SupplierSuccess) {
          await Future.delayed(Duration(seconds: 1));
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(progressSnackBar(message: state.message));
          await Future.delayed(Duration(milliseconds: 2500));
          Navigator.pushNamed(context, kExistingSuppliersScreen);
        }
      },
      child: Padding(
        padding: kPrimaryPadding,
        child: ListView(
          children: [
            InputField(
              child: TextField(
                maxLength: 35,
                controller: _supplierNameController,
                onChanged: (text) {
                  context.bloc<RandomCodeCubit>().generate(text);
                },
                decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  hintText: 'Supplier Name',
                ),
              ),
              iconData: Icons.person,
            ),
            BlocBuilder<RandomCodeCubit, String>(builder: (context, state) {
              _supplierCodeController.text = '$state';
              return InputField(
                child: TextField(
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
              child: TextField(
                maxLength: 15,
                controller: _contactController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Contact',
                  counterText: "",
                ),
              ),
              iconData: Icons.call,
            ),
            InputField(
              child: TextFormField(
                maxLength: 250,
                minLines: 1,
                maxLines: 2,
                controller: _addressController,
                decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  hintText: 'Address',
                ),
              ),
              iconData: Icons.home,
            ),
            InputField(
              child: TextField(
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
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await Future.delayed(Duration(milliseconds: 500));
                  uploadData();
                },
              ),
            ),
            FlatButton(
              child: Text('View existing suppliers'),
              onPressed: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.pushNamed(
                  context,
                  kExistingSuppliersScreen,
                );
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
