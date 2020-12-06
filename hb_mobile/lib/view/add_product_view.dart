import 'package:core/core.dart';
import 'package:core/src/business_logics/bloc/product_bloc/product_bloc.dart'
    as productBloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class AddProductScreen extends StatelessWidget {
  final String title;

  const AddProductScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => ProductBloc(),
          ),
          BlocProvider(
            create: (BuildContext context) => RandomCodeCubit("Product code"),
          ),
        ],
        child: AddProductForm(),
      ),
    );
  }
}

class AddProductForm extends StatefulWidget {
  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  ProductBloc _addProductBloc;
  TextEditingController _productNameController;
  TextEditingController _productCodeController;
  TextEditingController _salaryPerStrokeController;
  TextEditingController _unitPerStrokeController;
  TextEditingController _sellingUnitController;
  TextEditingController _pricePerSellingUnitController;
  TextEditingController _unitsPerSellingUnitController;

  @override
  void initState() {
    _addProductBloc = BlocProvider.of<ProductBloc>(context);
    _productNameController = TextEditingController();
    _productCodeController = TextEditingController();
    _salaryPerStrokeController = TextEditingController();
    _unitPerStrokeController = TextEditingController();
    _sellingUnitController = TextEditingController();
    _pricePerSellingUnitController = TextEditingController();
    _unitsPerSellingUnitController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productCodeController.dispose();
    _salaryPerStrokeController.dispose();
    _unitPerStrokeController.dispose();
    _sellingUnitController.dispose();
    _pricePerSellingUnitController.dispose();
    _unitsPerSellingUnitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, productBloc.ProductState>(
      listener: (BuildContext context, state) {
        if (state is ProductError) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              warningSnackBar(message: state.message),
            );
        }
        if (state is ProductLoading) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              progressSnackBar(
                message: state.message,
                child: CircularProgressIndicator(),
              ),
            );
        }
        if (state is ProductSuccess) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(progressSnackBar(message: state.message));
        }
      },
      child: Padding(
        padding: kPrimaryPadding,
        child: ListView(
          children: [
            _productName(context),
            _code(context),
            _salaryPerStroke(),
            _nosPerStroke(),
            _unit(),
            _pricePerUnit(),
            _nosPerSellingUnit(),
            _upload(),
            _navigation(context),
          ],
        ),
      ),
    );
  }

  SecondaryActionButton _navigation(BuildContext context) {
    return SecondaryActionButton(
      title: 'View existing products',
      onPressed: () => Navigator.pushNamed(context, kExistingProductScreen),
    );
  }

  Padding _upload() {
    return Padding(
      padding: kTopPadding,
      child: PrimaryActionButton(
        title: 'Upload',
        onPressed: () {
          uploadData();
        },
      ),
    );
  }

  TextFormField _nosPerSellingUnit() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _unitsPerSellingUnitController,
      maxLength: 10,
      decoration: InputDecoration(
        icon: Icon(Icons.chevron_right),
        labelText: 'No of Units Per selling unit',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  TextFormField _pricePerUnit() {
    return TextFormField(
      maxLength: 10,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        icon: rupee,
        labelText: 'Price per selling unit',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
      controller: _pricePerSellingUnitController,
    );
  }

  TextFormField _unit() {
    return TextFormField(
      controller: _sellingUnitController,
      maxLength: 10,
      decoration: InputDecoration(
        icon: Icon(Icons.bookmark),
        labelText: 'Selling unit',
        helperText: 'Load / unit (ltr, kg) etc..,',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  TextFormField _nosPerStroke() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _unitPerStrokeController,
      maxLength: 10,
      decoration: InputDecoration(
        icon: Icon(Icons.chevron_right),
        labelText: 'No of Unit Produced Per Stroke',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  TextFormField _salaryPerStroke() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _salaryPerStrokeController,
      maxLength: 10,
      decoration: InputDecoration(
        icon: rupee,
        labelText: 'Salary per stroke',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  Widget _code(BuildContext context) {
    return BlocBuilder<RandomCodeCubit, String>(
      builder: (context, state) {
        _productCodeController.text = '$state';
        return TextFormField(
          enabled: false,
          controller: _productCodeController,
          decoration: InputDecoration(
            icon: Icon(Icons.info),
            labelText: 'Product code',
            // helperText: '',
            enabledBorder: UnderlineInputBorder(),
          ),
        );
      },
    );
  }

  TextFormField _productName(BuildContext context) {
    return TextFormField(
      controller: _productNameController,
      onChanged: (text) {
        print(text);
        context.bloc<RandomCodeCubit>().generate(text);
      },
      maxLength: 30,
      decoration: InputDecoration(
        icon: Icon(Icons.bookmark),
        labelText: 'Product Name',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  void uploadData() {
    _addProductBloc.add(
      AddProduct(
        pname: _productNameController.text,
        pcode: _productCodeController.text,
        pricepersunit: _pricePerSellingUnitController.text,
        nospsunit: _unitsPerSellingUnitController.text,
        nosps: _unitPerStrokeController.text,
        salaryps: _salaryPerStrokeController.text,
        sunit: _sellingUnitController.text,
      ),
    );
  }
}
