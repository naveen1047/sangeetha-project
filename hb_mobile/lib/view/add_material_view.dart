import 'package:core/core.dart';
import 'package:core/src/business_logics/bloc/material_bloc.dart'
    as materialBloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class AddMaterialScreen extends StatelessWidget {
  final String title;

  const AddMaterialScreen({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => MaterialBloc(),
          ),
          BlocProvider(
            create: (BuildContext context) => RandomCodeCubit("Supplier code"),
          ),
        ],
        child: AddMaterialForm(),
      ),
    );
  }
}

class AddMaterialForm extends StatefulWidget {
  @override
  _AddMaterialFormState createState() => _AddMaterialFormState();
}

class _AddMaterialFormState extends State<AddMaterialForm> {
  MaterialBloc _addMaterialBloc;
  TextEditingController _materialNameController;
  TextEditingController _materialCodeController;
  TextEditingController _unitController;
  TextEditingController _priceController;

  @override
  void initState() {
    _addMaterialBloc = BlocProvider.of<MaterialBloc>(context);
    _materialNameController = TextEditingController();
    _materialCodeController = TextEditingController();
    _unitController = TextEditingController();
    _priceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _materialNameController.dispose();
    _materialCodeController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MaterialBloc, materialBloc.MaterialState>(
      listener: (BuildContext context, state) async {
        if (state is MaterialError) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              warningSnackBar(message: state.message),
            );
        }
        if (state is MaterialLoading) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              progressSnackBar(
                  message: state.message,
                  seconds: 1,
                  child: CircularProgressIndicator()),
            );
        }
        if (state is MaterialErrorAndClear) {
          await Future.delayed(Duration(milliseconds: 500));
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              warningSnackBar(message: state.message),
            );

          _materialNameController.clear();
          _materialCodeController.clear();
        }
        if (state is MaterialSuccess) {
          await Future.delayed(Duration(seconds: 1));
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(progressSnackBar(message: state.message));
          await Future.delayed(Duration(seconds: 3));
          Navigator.pushNamed(context, kExistingMaterialScreen);
        }
      },
      child: Padding(
        padding: kPrimaryPadding,
        child: ListView(
          children: [
            InputField(
              child: TextField(
                maxLength: 28,
                controller: _materialNameController,
                onChanged: (text) {
                  context.bloc<RandomCodeCubit>().generate(text);
                },
                decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  hintText: 'Material Name',
                ),
              ),
              iconData: Icons.bookmark,
            ),
            BlocBuilder<RandomCodeCubit, String>(builder: (context, state) {
              _materialCodeController.text = '$state';
              return InputField(
                child: TextField(
                  enabled: false,
                  controller: _materialCodeController,
                  decoration: InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                    hintText: 'Material code',
                  ),
                ),
                iconData: Icons.info,
                isDisabled: true,
              );
            }),
            InputField(
              child: TextField(
                maxLength: 13,
                controller: _unitController,
                decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  hintText: 'Unit (kg, load etc..,)',
                ),
              ),
              iconData: Icons.arrow_forward_ios,
            ),
            InputField(
              child: TextField(
                keyboardType: TextInputType.number,
                maxLength: 6,
                controller: _priceController,
                decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  hintText: 'Price per unit',
                ),
              ),
              iconData: Icons.attach_money,
            ),
            Padding(
              padding: kTopPadding,
              child: PrimaryActionButton(
                title: 'Upload',
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  uploadData();
                },
              ),
            ),
            FlatButton(
              child: Text('View existing materials'),
              onPressed: () {
                Navigator.pushNamed(context, kExistingMaterialScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  void uploadData() {
    _addMaterialBloc.add(
      AddMaterial(
        mname: _materialNameController.text,
        mpriceperunit: _priceController.text,
        mcode: _materialCodeController.text,
        munit: _unitController.text,
      ),
    );
  }
}
