import 'package:core/core.dart';
import 'package:core/src/business_logics/bloc/material_bloc.dart'
    as materialBloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class MaterialBottomSheet extends StatefulWidget {
  final viewMaterialBloc;
  final String materialcode;
  final String materialName;
  final String materialUnit;
  final String materialPrice;

  const MaterialBottomSheet({
    Key key,
    @required this.materialcode,
    @required this.materialName,
    @required this.materialUnit,
    @required this.materialPrice,
    this.viewMaterialBloc,
  }) : super(key: key);

  @override
  _MaterialBottomSheetState createState() => _MaterialBottomSheetState();
}

class _MaterialBottomSheetState extends State<MaterialBottomSheet> {
  MaterialBloc _addMaterialBloc;
  TextEditingController _materialNameController;
  TextEditingController _materialCodeController;
  TextEditingController _materialUnitController;
  TextEditingController _materialPriceController;

  @override
  void initState() {
    _addMaterialBloc = BlocProvider.of<MaterialBloc>(context);
    _materialNameController = TextEditingController();
    _materialCodeController = TextEditingController();
    _materialUnitController = TextEditingController();
    _materialPriceController = TextEditingController();
    setValues();
    super.initState();
  }

  void setValues() {
    _materialNameController.text = widget.materialName;
    _materialCodeController.text = widget.materialcode;
    _materialUnitController.text = widget.materialUnit;
    _materialPriceController.text = widget.materialPrice;
  }

  @override
  void dispose() {
    _materialNameController.dispose();
    _materialCodeController.dispose();
    _materialUnitController.dispose();
    _materialPriceController.dispose();
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
          BlocListener<MaterialBloc, materialBloc.MaterialState>(
            listener: (context, state) async {
              if (state is MaterialSuccess) {
                await Future.delayed(Duration(seconds: 1));
                widget.viewMaterialBloc.add(FetchMaterialEvent());
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<MaterialBloc, materialBloc.MaterialState>(
              builder: (context, state) {
                if (state is MaterialSuccess) {
                  return message("Value changed successfully");
                }
                if (state is MaterialLoading) {
                  return message(
                    "Updating...",
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is MaterialError) {
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
                    child: Text('Edit Material'),
                  );
                }
              },
            ),
          ),
          InputField(
            child: TextField(
              controller: _materialNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Material Name',
              ),
            ),
            iconData: Icons.bookmark,
          ),
          InputField(
            child: TextField(
              enabled: false,
              controller: _materialCodeController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Material code',
              ),
            ),
            iconData: Icons.info,
            isDisabled: true,
          ),
          InputField(
            child: TextField(
              controller: _materialUnitController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Unit',
              ),
            ),
            iconData: Icons.chevron_right,
          ),
          InputField(
            child: TextField(
              controller: _materialPriceController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Price per unit',
              ),
            ),
            iconData: Icons.attach_money,
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
    _addMaterialBloc
      ..add(
        EditMaterial(
          mname: _materialNameController.text,
          mpriceperunit: _materialPriceController.text,
          mcode: _materialCodeController.text,
          munit: _materialUnitController.text,
        ),
      );
  }
}
