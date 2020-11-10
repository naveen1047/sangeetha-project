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
        if (state is ProductUploading) {
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
            InputField(
              child: TextField(
                controller: _productNameController,
                onChanged: (text) {
                  context.bloc<RandomCodeCubit>().generate(text);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Product Name',
                ),
              ),
              iconData: Icons.bookmark,
            ),
            BlocBuilder<RandomCodeCubit, String>(builder: (context, state) {
              _productCodeController.text = '$state';
              return InputField(
                child: TextField(
                  enabled: false,
                  controller: _productCodeController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Product code',
                  ),
                ),
                iconData: Icons.info,
                isDisabled: true,
              );
            }),
            InputField(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _salaryPerStrokeController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Salary per stroke',
                ),
              ),
              iconData: Icons.attach_money,
            ),
            InputField(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _unitPerStrokeController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'No of Unit Produced Per Stroke',
                ),
              ),
              iconData: Icons.arrow_forward_ios,
            ),
            InputField(
              child: TextField(
                controller: _sellingUnitController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Load, unit etc..,',
                ),
              ),
              iconData: Icons.bookmark,
            ),
            InputField(
              child: TextField(
                controller: _pricePerSellingUnitController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Price per selling unit',
                ),
              ),
              iconData: Icons.attach_money,
            ),
            InputField(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _unitsPerSellingUnitController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'No of Units Per selling unit',
                ),
              ),
              iconData: Icons.arrow_forward_ios,
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
              child: Text('View existing products'),
              onPressed: () {
                // Navigator.pushNamed(context, kExistingProductScreen);
              },
            ),
          ],
        ),
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
