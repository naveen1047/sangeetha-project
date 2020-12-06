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
          _code(),
          _productName(),
          _salaryPerStroke(),
          _nosPerStroke(),
          _unit(),
          _pricePerUnit(),
          _nosPerSellingUnit(),
          _action(context)
        ],
      ),
    );
  }

  Padding _action(BuildContext context) {
    return Padding(
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
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
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

  TextFormField _productName() {
    return TextFormField(
      controller: _productNameController,
      maxLength: 30,
      decoration: InputDecoration(
        icon: Icon(Icons.bookmark),
        labelText: 'Product Name',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  Widget _code() {
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
