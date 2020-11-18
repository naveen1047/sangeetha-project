import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/navigate_back_widget.dart';

class AddCustomersScreen extends StatelessWidget {
  final String title;

  const AddCustomersScreen({Key key, this.title}) : super(key: key);
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
            create: (BuildContext context) => CustomerBloc(),
          ),
          BlocProvider(
            create: (BuildContext context) => RandomCodeCubit("Customer code"),
          ),
        ],
        child: AddCustomerForm(),
      ),
    );
  }
}

class AddCustomerForm extends StatefulWidget {
  @override
  _AddCustomerFormState createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
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
    setDate();
    super.initState();
  }

  void setDate() {
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
    return BlocListener<CustomerBloc, CustomerState>(
      listener: (BuildContext context, state) async {
        if (state is CustomerError) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              warningSnackBar(message: state.message),
            );
        }
        if (state is CustomerLoading) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              progressSnackBar(
                  message: state.message,
                  seconds: 1,
                  child: CircularProgressIndicator()),
            );
        }
        if (state is CustomerErrorAndClear) {
          await Future.delayed(Duration(milliseconds: 500));
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              warningSnackBar(message: state.message),
            );

          _customerNameController.clear();
          _customerCodeController.clear();
        }
        if (state is CustomerSuccess) {
          await Future.delayed(Duration(seconds: 1));
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(progressSnackBar(message: state.message));
          await Future.delayed(Duration(milliseconds: 2500));
          // Navigator.pushNamed(context, kExistingCustomersScreen);
        }
      },
      child: Padding(
        padding: kPrimaryPadding,
        child: ListView(
          children: [
            InputField(
              child: TextField(
                maxLength: 35,
                controller: _customerNameController,
                onChanged: (text) {
                  context.bloc<RandomCodeCubit>().generate(text);
                },
                decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  hintText: 'Customer Name',
                ),
              ),
              iconData: Icons.person,
            ),
            BlocBuilder<RandomCodeCubit, String>(builder: (context, state) {
              _customerCodeController.text = '$state';
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
              child: Text('View existing customers'),
              onPressed: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                // Navigator.pushNamed(
                //   context,
                //   kExistingCustomersScreen,
                // );
              },
            ),
          ],
        ),
      ),
    );
  }

  void uploadData() {
    _addCustomerBloc.add(
      AddCustomer(
        cname: _customerNameController.text,
        caddate: _addDateController.text,
        caddress: _addressController.text,
        ccode: _customerCodeController.text,
        cnum: _contactController.text,
      ),
    );
  }
}
