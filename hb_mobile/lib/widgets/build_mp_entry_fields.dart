import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/view/edit_mp_view.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:core/core.dart';
import 'package:core/src/business_logics/models/material.dart' as m;

import '../constant.dart';

class BuildEntryFields extends StatefulWidget {
  final List<SupplierNameCode> suppliers;
  final List<m.Material> materials;
  final bool isEditable;
  final MaterialPurchase mp;

  const BuildEntryFields({
    Key key,
    this.suppliers,
    this.materials,
    this.isEditable = false,
    this.mp,
  }) : super(key: key);

  @override
  _BuildEntryFieldsState createState() =>
      _BuildEntryFieldsState(suppliers, materials);
}

class _BuildEntryFieldsState extends State<BuildEntryFields> {
  MPBloc _mpBloc;
  List<SupplierNameCode> suppliers;
  List<m.Material> materials;
  TextEditingController _billNoController;
  TextEditingController _quantityController;
  TextEditingController _unitPriceController;
  TextEditingController _totalPriceController;
  TextEditingController _remarksController;
  TextEditingController _dateController;
  MaterialPurchase mp;

  _BuildEntryFieldsState(
      List<SupplierNameCode> suppliers, List<m.Material> materials) {
    this.suppliers = suppliers;
    this.materials = materials;
  }

  String selectedSupplier;
  String selectedMaterial;
  bool isDisabled = true;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    _mpBloc = BlocProvider.of<MPBloc>(context);

    _billNoController = TextEditingController();
    _quantityController = TextEditingController();
    _unitPriceController = TextEditingController();
    _totalPriceController = TextEditingController();
    _remarksController = TextEditingController();
    _dateController = TextEditingController();
    _dateController.text = selectedDate.toString();

    _unitPriceController.text = '0';

    if (widget.isEditable) {
      selectedDate = DateTime.parse(widget.mp.date);
      context.bloc<DatePickerCubit>().selectDate(selectedDate);

      _billNoController.text = widget.mp.billno;
      _quantityController.text = widget.mp.quantity;
      _unitPriceController.text = widget.mp.unitprice;
      _totalPriceController.text = widget.mp.price;
      _remarksController.text = widget.mp.remarks;
      _dateController.text = widget.mp.date;

      _unitPriceController.text = widget.mp.unitprice;

      selectedSupplier = widget.mp.scode;
      selectedMaterial = widget.mp.mcode;

      calculatePrice(widget.mp.unitprice, widget.mp.quantity);
    }

    super.initState();
  }

  void calculatePrice(String unitPrice, String quantity) {
    double p;
    double q;
    if (unitPrice != null &&
        unitPrice != "" &&
        quantity != null &&
        quantity != "") {
      p = double.parse(unitPrice);
      q = double.parse(quantity);
    } else {
      p = 0.0;
      q = 0.0;
    }
    context.bloc<TotalPriceCubit>()
      ..setQuantity(q)
      ..setPrice(p);
  }

  @override
  void dispose() {
    _billNoController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _totalPriceController.dispose();
    _remarksController.dispose();
    _dateController.dispose();
    _mpBloc.close();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        context.bloc<DatePickerCubit>().selectDate(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPrimaryPadding,
      child: ListView(
        children: [
          _billNo(),
          _datePicker(context),
          _supplierDropdown(),
          _materialDropdown(context),
          _unitPrice(context),
          _quantity(context),
          _totalPrice(),
          _remarks(context),
          _upload(context),
          widget.isEditable ? _cancel(context) : _navigator(context),
        ],
      ),
    );
  }

  TextFormField _remarks(BuildContext context) {
    return TextFormField(
      controller: _remarksController,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      minLines: 1,
      maxLength: 250,
      decoration: InputDecoration(
        hintText: '(optional)',
        icon: Icon(Icons.report_gmailerrorred_outlined),
        labelText: 'Remarks',

        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  TextFormField _quantity(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _quantityController,
      onChanged: (text) {
        double q;
        if (text != null && text != "") {
          q = double.parse(text);
        } else {
          q = 0.0;
        }
        context.bloc<TotalPriceCubit>().setQuantity(q);
      },
      maxLength: 10,
      decoration: InputDecoration(
        icon: Icon(Icons.chevron_right),
        labelText: 'Quantity',

        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  BlocBuilder<TotalPriceCubit, double> _totalPrice() {
    return BlocBuilder<TotalPriceCubit, double>(
      builder: (BuildContext context, state) {
        _totalPriceController.text = '$state';
        return TextFormField(
          keyboardType: TextInputType.number,
          controller: _totalPriceController,
          maxLength: 12,
          decoration: InputDecoration(
            icon: rupee,
            labelText: 'Total price',

            // helperText: '',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
        );
      },
    );
  }

  Padding _unitPrice(BuildContext context) {
    return Padding(
      padding: kTopPadding,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _unitPriceController,
              enabled: !isDisabled,
              onChanged: (text) {
                double p;
                print("a");
                if (text != null && text != "") {
                  p = double.parse(text);
                } else {
                  p = 0.0;
                }
                context.bloc<TotalPriceCubit>().setPrice(p);
              },
              maxLength: 10,
              decoration: InputDecoration(
                icon: rupee,
                labelText: 'Unit price',

                // helperText: '',
                enabledBorder: UnderlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isDisabled = !isDisabled;
              });
            },
          ),
        ],
      ),
    );
  }

  TextFormField _billNo() {
    return TextFormField(
      maxLength: 20,
      enabled: !widget.isEditable,
      decoration: InputDecoration(
        icon: Icon(Icons.notes),
        labelText: 'Bill No',
        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
      controller: _billNoController,
    );
  }

  GestureDetector _datePicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        return _selectDate(context);
      },
      child: Padding(
        padding: kVerticalPadding,
        child: Container(
          child: BlocBuilder<DatePickerCubit, String>(
            builder: (BuildContext context, state) {
              _dateController.text = state;
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: kRightPadding,
                    child: Icon(Icons.date_range),
                  ),
                  Expanded(
                    child: Padding(
                      padding: kLeftPadding,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _dateController.text,
                              ),
                              Icon(Icons.edit),
                            ],
                          ),
                          Padding(
                            padding: kTopPadding,
                            child: Divider(
                              thickness: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  FlatButton _navigator(BuildContext context) {
    return FlatButton(
      child: Text('View Materials purchase'),
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pushNamed(context, kExistingMaterialPurchase);
      },
    );
  }

  FlatButton _cancel(BuildContext context) {
    return FlatButton(
      child: Text('Cancel'),
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pop(context);
      },
    );
  }

  Padding _upload(BuildContext context) {
    return Padding(
      padding: kTopPadding,
      child: PrimaryActionButton(
        title: widget.isEditable ? 'Change' : 'Upload',
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          uploadData();
        },
      ),
    );
  }

  Widget _materialDropdown(BuildContext context) {
    return Padding(
      padding: kTopPadding,
      child: Row(
        children: [
          Padding(
            padding: kRightPadding,
            child: Icon(Icons.anchor),
          ),
          Expanded(
            child: Padding(
              padding: kLeftPadding,
              child: DropdownButtonHideUnderline(
                child: DropdownDecorator(
                  child: DropdownButton<String>(
                    hint: Text("Select Material"),
                    value: selectedMaterial,
                    onChanged: (String newValue) {
                      setState(() {
                        selectedMaterial = newValue;
                        var material = materials.where(
                            (element) => element.mcode == selectedMaterial);
                        _unitPriceController.text =
                            material.first.mpriceperunit.toString();
                        context.bloc<TotalPriceCubit>().setPrice(
                            double.parse(material.first.mpriceperunit));
                      });
                      print(selectedMaterial);
                    },
                    items: materials.map((m.Material m) {
                      return DropdownMenuItem<String>(
                        value: m.mcode,
                        child: Text('${m.mname} - ${m.munit}'),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _supplierDropdown() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: kRightPadding,
          child: Icon(Icons.person_rounded),
        ),
        Expanded(
          child: Padding(
            padding: kLeftPadding,
            child: DropdownButtonHideUnderline(
              child: DropdownDecorator(
                child: DropdownButton<String>(
                  hint: Text("Select Supplier"),
                  value: selectedSupplier,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedSupplier = newValue;
                    });
                    print(selectedSupplier);
                  },
                  items: suppliers.map((SupplierNameCode s) {
                    return DropdownMenuItem<String>(
                      value: s.scode,
                      child: Text(s.sname),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void uploadData() {
    print(selectedSupplier);
    _mpBloc.add(UploadMPEntry(
      mpcode: _billNoController.text,
      scode: selectedSupplier,
      date: _dateController.text,
      billno: _billNoController.text,
      mcode: selectedMaterial,
      quantity: _quantityController.text,
      unitprice: _unitPriceController.text,
      price: _totalPriceController.text,
      remarks: _remarksController.text,
    ));
  }
}
