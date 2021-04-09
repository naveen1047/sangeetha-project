import 'package:core/core.dart';
// import 'package:core/src/business_logics/bloc/stock_bloc/stock_bloc.dart'
// as stockBloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class StockDetailBottomSheet extends StatefulWidget {
  final viewStockDetailBloc;
  final String pName;
  final String lStock;
  final String rStock;
  final String tStock;
  final String pcode;

  const StockDetailBottomSheet({
    Key key,
    @required this.lStock,
    @required this.rStock,
    @required this.tStock,
    @required this.pName,
    this.viewStockDetailBloc,
    this.pcode,
  }) : super(key: key);

  @override
  _StockDetailBottomSheetState createState() => _StockDetailBottomSheetState();
}

class _StockDetailBottomSheetState extends State<StockDetailBottomSheet> {
  StockDetailsBloc _editStockDetailBloc;
  TextEditingController _pNameController;
  TextEditingController _lStockController;
  TextEditingController _rStockController;
  TextEditingController _tStockController;
  String pcode;

  @override
  void initState() {
    _editStockDetailBloc = BlocProvider.of<StockDetailsBloc>(context);
    _pNameController = TextEditingController();
    _lStockController = TextEditingController();
    _rStockController = TextEditingController();
    _tStockController = TextEditingController();
    setValues();
    super.initState();
  }

  void setValues() {
    pcode = widget.pcode;
    _pNameController.text = widget.pName;
    _lStockController.text = widget.lStock;
    _rStockController.text = widget.rStock;
    _tStockController.text = widget.tStock;
  }

  @override
  void dispose() {
    _pNameController.dispose();
    _lStockController.dispose();
    _rStockController.dispose();
    _tStockController.dispose();
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
          BlocListener<StockDetailsBloc, StockDetailsState>(
            listener: (context, state) async {
              if (state is StockDetailsSuccess) {
                await Future.delayed(Duration(seconds: 1));
                widget.viewStockDetailBloc.add(FetchStocksEvent());
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<StockDetailsBloc, StockDetailsState>(
              builder: (context, state) {
                if (state is StockDetailsSuccess) {
                  return message("Value changed successfully");
                }
                if (state is StockDetailsLoading) {
                  return message(
                    "Updating...",
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is StockDetailsError) {
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
                    child: Text('Edit StockDetail'),
                  );
                }
              },
            ),
          ),
          // _code(),
          _pName(),
          _lStock(),
          _rStock(),
          _tStock(),
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

  TextFormField _tStock() {
    return TextFormField(
      maxLength: 10,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        icon: Icon(Icons.done_all),
        labelText: 'Total Stock',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
      controller: _tStockController,
    );
  }

  TextFormField _rStock() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _rStockController,
      maxLength: 10,
      decoration: InputDecoration(
        icon: Icon(Icons.chevron_right),
        labelText: 'Recent stock',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  TextFormField _lStock() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _lStockController,
      maxLength: 10,
      decoration: InputDecoration(
        icon: rupee,
        labelText: 'Last Stock',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  TextFormField _pName() {
    return TextFormField(
      controller: _pNameController,
      enabled: false,
      maxLength: 30,
      decoration: InputDecoration(
        icon: Icon(Icons.bookmark),
        labelText: 'Product',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  // Widget _code() {
  //   return TextFormField(
  //     enabled: false,
  //     controller: _stockCodeController,
  //     decoration: InputDecoration(
  //       icon: Icon(Icons.info),
  //       labelText: 'StockDetail code',
  //       // helperText: '',
  //       enabledBorder: UnderlineInputBorder(),
  //     ),
  //   );
  // }

  void _uploadData() {
    _editStockDetailBloc
      ..add(
        EditStock(
          pcode,
          _tStockController.text,
          _rStockController.text,
          _lStockController.text,
        ),
      );
  }
}
