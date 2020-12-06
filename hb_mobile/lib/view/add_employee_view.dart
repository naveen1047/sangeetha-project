import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/navigate_back_widget.dart';

class AddEmployeeScreen extends StatelessWidget {
  final String title;

  const AddEmployeeScreen({Key key, this.title}) : super(key: key);

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
            create: (BuildContext context) => EmployeeBloc(),
          ),
          BlocProvider(
            create: (BuildContext context) => RandomCodeCubit("Employee code"),
          ),
        ],
        child: AddEmployeeForm(),
      ),
    );
  }
}

class AddEmployeeForm extends StatefulWidget {
  @override
  _AddEmployeeFormState createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<AddEmployeeForm> {
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
    setDate();
    super.initState();
  }

  void setDate() {
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
    return BlocListener<EmployeeBloc, EmployeeState>(
      listener: (BuildContext context, state) async {
        if (state is EmployeeError) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              warningSnackBar(message: state.message),
            );
        }
        if (state is EmployeeLoading) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              progressSnackBar(
                  message: state.message,
                  seconds: 1,
                  child: CircularProgressIndicator()),
            );
        }
        if (state is EmployeeErrorAndClear) {
          await Future.delayed(Duration(milliseconds: 500));
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              warningSnackBar(message: state.message),
            );

          _employeeNameController.clear();
          _employeeCodeController.clear();
        }
        if (state is EmployeeSuccess) {
          await Future.delayed(Duration(seconds: 1));
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(progressSnackBar(message: state.message));
          await Future.delayed(Duration(milliseconds: 2500));
          Navigator.pushNamed(context, kExistingEmployeeScreen);
        }
      },
      child: Padding(
        padding: kPrimaryPadding,
        child: ListView(
          children: [
            _name(context),
            _code(),
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
      child: Text(
        'View existing employees',
        // style: TextStyle(color: kTextColor),
      ),
      onPressed: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pushNamed(context, kExistingEmployeeScreen);
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
    return BlocBuilder<RandomCodeCubit, String>(builder: (context, state) {
      _employeeCodeController.text = '$state';
      return TextFormField(
        enabled: false,
        controller: _employeeCodeController,
        onChanged: (text) {
          print(text);
          context.bloc<RandomCodeCubit>().generate(text);
        },
        decoration: InputDecoration(
          icon: Icon(Icons.info),
          labelText: 'Employee code',
          // helperText: '',
          enabledBorder: UnderlineInputBorder(),
        ),
      );
    });
  }

  TextFormField _name(BuildContext context) {
    return TextFormField(
      controller: _employeeNameController,
      onChanged: (text) {
        context.bloc<RandomCodeCubit>().generate(text);
      },
      maxLength: 28,
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Employee Name',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  void uploadData() {
    _addEmployeeBloc.add(
      AddEmployee(
        ename: _employeeNameController.text,
        eaddate: _addDateController.text,
        eaddress: _addressController.text,
        ecode: _employeeCodeController.text,
        enumber: _contactController.text,
      ),
    );
  }
}
