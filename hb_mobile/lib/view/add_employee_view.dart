import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class AddEmployeeScreen extends StatelessWidget {
  final String title;

  const AddEmployeeScreen({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
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
      listener: (BuildContext context, state) {
        if (state is EmployeeError) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              warningSnackBar(message: state.message),
            );
        }
        if (state is EmployeeSuccess) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(progressSnackBar(message: state.message));
        }
      },
      child: Padding(
        padding: kPrimaryPadding,
        child: ListView(
          children: [
            InputField(
              textField: TextField(
                controller: _employeeNameController,
                onChanged: (text) {
                  context.bloc<RandomCodeCubit>().generate(text);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Employee Name',
                ),
              ),
              iconData: Icons.person,
            ),
            BlocBuilder<RandomCodeCubit, String>(builder: (context, state) {
              _employeeCodeController.text = '$state';
              return InputField(
                textField: TextField(
                  enabled: false,
                  controller: _employeeCodeController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Employee code',
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
              child: Text('View existing employees'),
              onPressed: () {
                Navigator.pushNamed(context, kExistingEmployeeScreen);
              },
            ),
          ],
        ),
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
