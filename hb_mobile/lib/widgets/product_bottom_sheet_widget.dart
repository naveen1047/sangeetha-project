import 'package:core/core.dart';
// import 'package:core/src/business_logics/bloc/product_bloc/product_bloc.dart'
// as productBloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class ProductBottomSheet extends StatefulWidget {
  final viewProductBloc;
  final String productName;
  final String productCode;
  final String salaryPerStroke;
  final String unitPerStroke;
  final String sellingUnit;
  final String pricePerSellingUnit;
  final String unitsPerSellingUnit;

  const ProductBottomSheet({
    Key key,
    @required this.productCode,
    @required this.productName,
    this.viewProductBloc,
    this.salaryPerStroke,
    this.unitPerStroke,
    this.sellingUnit,
    this.pricePerSellingUnit,
    this.unitsPerSellingUnit,
  }) : super(key: key);

  @override
  _ProductBottomSheetState createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
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
    setValues();
    super.initState();
  }

  void setValues() {
    _productNameController.text = widget.productName;
    _productCodeController.text = widget.productCode;
    _salaryPerStrokeController.text = widget.salaryPerStroke;
    _unitPerStrokeController.text = widget.unitPerStroke;
    _sellingUnitController.text = widget.sellingUnit;
    _pricePerSellingUnitController.text = widget.pricePerSellingUnit;
    _unitsPerSellingUnitController.text = widget.unitsPerSellingUnit;
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
    return Padding(
      padding: kPrimaryPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BlocListener<ProductBloc, ProductState>(
            listener: (context, state) async {
              if (state is ProductSuccess) {
                await Future.delayed(Duration(seconds: 1));
                widget.viewProductBloc.add(FetchProductEvent());
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductSuccess) {
                  return message("Value changed successfully");
                }
                if (state is ProductLoading) {
                  return message(
                    "Updating...",
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProductError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${state.message}',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Edit Product'),
                  );
                }
              },
            ),
          ),
          InputField(
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
          ),
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PrimaryActionButton(
                  title: 'Change',
                  onPressed: () {
                    _uploadData();
                  },
                ),
                RaisedButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _uploadData() {
    _addProductBloc
      ..add(
        EditProduct(
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
