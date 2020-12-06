import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/navigate_back_widget.dart';

class AddSuppliersScreen extends StatelessWidget {
  final String title;

  const AddSuppliersScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: NavigateBackButton(),
      ),
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
            _name(context),
            _code(context),
            _contact(),
            _address(),
            _date(),
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
            _navigator(context),
          ],
        ),
      ),
    );
  }

  FlatButton _navigator(BuildContext context) {
    return FlatButton(
      child: Text('View existing suppliers'),
      onPressed: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pushNamed(
          context,
          kExistingSuppliersScreen,
        );
      },
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
    return BlocBuilder<RandomCodeCubit, String>(
      builder: (context, state) {
        _supplierCodeController.text = '$state';
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
      },
    );
  }

  TextFormField _name(BuildContext context) {
    return TextFormField(
      controller: _supplierNameController,
      onChanged: (text) {
        print(text);
        context.bloc<RandomCodeCubit>().generate(text);
      },
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
