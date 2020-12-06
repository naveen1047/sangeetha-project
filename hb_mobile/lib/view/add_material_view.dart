import 'package:core/core.dart';
import 'package:core/src/business_logics/bloc/material_bloc/material_bloc.dart'
    as materialBloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/navigate_back_widget.dart';

class AddMaterialScreen extends StatelessWidget {
  final String title;

  const AddMaterialScreen({Key key, this.title}) : super(key: key);
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
            _name(context),
            _code(),
            _unit(),
            _pricePerUnit(),
            _upload(context),
            _navigator(context),
          ],
        ),
      ),
    );
  }

  // InputField _pricePerUnit() {
  //   return InputField(
  //     child: TextField(
  //       keyboardType: TextInputType.number,
  //       maxLength: 6,
  //       controller: _priceController,
  //       decoration: InputDecoration(
  //         counterText: "",
  //         border: InputBorder.none,
  //         hintText: 'Price per unit',
  //       ),
  //     ),
  //     iconData: Icons.attach_money,
  //   );
  // }
  TextFormField _pricePerUnit() {
    return TextFormField(
      keyboardType: TextInputType.number,
      maxLength: 6,
      controller: _priceController,
      decoration: InputDecoration(
        icon: rupee,
        labelText: 'Price per unit',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }
  // InputField _unit() {
  //   return InputField(
  //     child: TextField(
  //       maxLength: 13,
  //       controller: _unitController,
  //       decoration: InputDecoration(
  //         counterText: "",
  //         border: InputBorder.none,
  //         hintText: 'Unit (kg, load etc..,)',
  //       ),
  //     ),
  //     iconData: Icons.arrow_forward_ios,
  //   );
  // }

  TextFormField _unit() {
    return TextFormField(
      maxLength: 13,
      controller: _unitController,
      decoration: InputDecoration(
        icon: Icon(Icons.chevron_right),
        labelText: 'Unit',
        helperText: 'Unit (kg, load etc..,)',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  FlatButton _navigator(BuildContext context) {
    return FlatButton(
      child: Text('View existing materials'),
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pushNamed(context, kExistingMaterialScreen);
      },
    );
  }

  Padding _upload(BuildContext context) {
    return Padding(
      padding: kTopPadding,
      child: PrimaryActionButton(
        title: 'Upload',
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          uploadData();
        },
      ),
    );
  }

  // BlocBuilder<RandomCodeCubit, String> _code() {
  //   return BlocBuilder<RandomCodeCubit, String>(builder: (context, state) {
  //     _materialCodeController.text = '$state';
  //     return InputField(
  //       child: TextField(
  //         enabled: false,
  //         controller: _materialCodeController,
  //         decoration: InputDecoration(
  //           counterText: "",
  //           border: InputBorder.none,
  //           hintText: 'Material code',
  //         ),
  //       ),
  //       iconData: Icons.info,
  //       isDisabled: true,
  //     );
  //   });
  // }

  Widget _code() {
    return BlocBuilder<RandomCodeCubit, String>(builder: (context, state) {
      _materialCodeController.text = '$state';
      return TextFormField(
        enabled: false,
        controller: _materialCodeController,
        onChanged: (text) {
          print(text);
          context.bloc<RandomCodeCubit>().generate(text);
        },
        decoration: InputDecoration(
          icon: Icon(Icons.info),
          labelText: 'Material code',
          // helperText: '',
          enabledBorder: UnderlineInputBorder(),
        ),
      );
    });
  }

  // InputField _name(BuildContext context) {
  //   return InputField(
  //     child: TextField(
  //       maxLength: 28,
  //       controller: _materialNameController,
  //       onChanged: (text) {
  //         context.bloc<RandomCodeCubit>().generate(text);
  //       },
  //       decoration: InputDecoration(
  //         counterText: "",
  //         border: InputBorder.none,
  //         hintText: 'Material Name',
  //       ),
  //     ),
  //     iconData: Icons.bookmark,
  //   );
  // }

  TextFormField _name(BuildContext context) {
    return TextFormField(
      controller: _materialNameController,
      onChanged: (text) {
        print(text);
        context.bloc<RandomCodeCubit>().generate(text);
      },
      maxLength: 28,
      decoration: InputDecoration(
        icon: Icon(Icons.bookmark),
        labelText: 'Material Name',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
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
