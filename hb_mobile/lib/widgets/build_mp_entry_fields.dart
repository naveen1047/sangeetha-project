import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:core/core.dart';
import 'package:core/src/business_logics/models/material.dart' as m;

import '../constant.dart';

class BuildEntryFields extends StatefulWidget {
  final List<SupplierNameCode> suppliers;
  final List<m.Material> materials;

  const BuildEntryFields({Key key, this.suppliers, this.materials})
      : super(key: key);

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
    // selectedSupplier = suppliers[0].scode;
    // selectedMaterial = materials[0].mcode;

    _billNoController = TextEditingController();
    _quantityController = TextEditingController();
    _unitPriceController = TextEditingController();
    _totalPriceController = TextEditingController();
    _remarksController = TextEditingController();
    _dateController = TextEditingController();
    _dateController.text = selectedDate.toString();

    _unitPriceController.text = '0';

    super.initState();
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
          _billNo(context),
          _datePicker(context),
          _supplierDropdown(),
          _materialDropdown(context),
          Padding(
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
                    cursorColor: isDisabled
                        ? Colors.grey
                        : Theme.of(context).cursorColor,
                    maxLength: 20,
                    decoration: InputDecoration(
                      icon: Icon(Icons.money_sharp),
                      labelText: 'Unit price',
                      labelStyle: TextStyle(
                        color: Color(0xFF6200EE),
                      ),
                      // helperText: '',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6200EE)),
                      ),
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
          ),
          // _unitPrice(context),
          TextFormField(
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
            cursorColor: Theme.of(context).cursorColor,
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.chevron_right),
              labelText: 'Quantity',
              labelStyle: TextStyle(
                color: Color(0xFF6200EE),
              ),
              // helperText: '',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6200EE)),
              ),
            ),
          ),
          // _quantity(context),
          // _totalPrice(),
          BlocBuilder<TotalPriceCubit, double>(
            builder: (BuildContext context, state) {
              _totalPriceController.text = '$state';
              return TextFormField(
                keyboardType: TextInputType.number,
                controller: _totalPriceController,
                cursorColor: Theme.of(context).cursorColor,
                maxLength: 20,
                decoration: InputDecoration(
                  icon: Icon(Icons.money_sharp),
                  labelText: 'Total price',
                  labelStyle: TextStyle(
                    color: Color(0xFF6200EE),
                  ),
                  // helperText: '',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6200EE)),
                  ),
                ),
              );
            },
          ),
          TextFormField(
            cursorColor: Theme.of(context).cursorColor,
            controller: _remarksController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            minLines: 1,
            maxLength: 30,
            decoration: InputDecoration(
              hintText: '(optional)',
              icon: Icon(Icons.report_gmailerrorred_outlined),
              labelText: 'Remarks',
              labelStyle: TextStyle(
                color: Color(0xFF6200EE),
              ),
              // helperText: '',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6200EE)),
              ),
            ),
          ),
          // _remarks(),
          _uplaod(context),
          _navigator(context),
        ],
      ),
    );
  }

  TextFormField _billNo(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).cursorColor,
      maxLength: 20,
      decoration: InputDecoration(
        icon: Icon(Icons.notes),
        labelText: 'Bill No',
        labelStyle: TextStyle(
          color: Color(0xFF6200EE),
        ),
        // helperText: '',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
        ),
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
                                state,
                              ),
                              Icon(Icons.edit, color: kActionIconColor),
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
        // Navigator.pushNamed(context, kExistingMaterialScreen);
      },
    );
  }

  Padding _uplaod(BuildContext context) {
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

  InputField _remarks() {
    return InputField(
      child: TextField(
        controller: _remarksController,
        decoration: InputDecoration(
          counterText: "",
          border: InputBorder.none,
          hintText: 'Remarks  (Optional)',
        ),
      ),
      iconData: Icons.report,
    );
  }

  BlocBuilder<TotalPriceCubit, double> _totalPrice() {
    return BlocBuilder<TotalPriceCubit, double>(
        builder: (BuildContext context, state) {
      _totalPriceController.text = '$state';
      return InputField(
        child: TextField(
          keyboardType: TextInputType.number,
          controller: _totalPriceController,
          decoration: InputDecoration(
            counterText: "",
            border: InputBorder.none,
            hintText: 'Total Price',
          ),
        ),
        iconData: Icons.attach_money_sharp,
      );
    });
  }

  InputField _quantity(BuildContext context) {
    return InputField(
      child: TextField(
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
        decoration: InputDecoration(
          counterText: "",
          border: InputBorder.none,
          hintText: 'Quantity',
        ),
      ),
      iconData: Icons.chevron_right,
    );
  }

  InputField _unitPrice(BuildContext context) {
    return InputField(
      isDisabled: isDisabled,
      child: TextField(
        decoration: InputDecoration(
          counterText: "",
          border: InputBorder.none,
          hintText: 'Unit Price',
        ),
      ),
      iconData: Icons.attach_money_sharp,
      trailing: Container(
        decoration: kOutBdrDisabledDecoration,
        child: IconButton(
          icon: Icon(
            Icons.edit,
            color: kActionIconColor,
          ),
          onPressed: () {
            setState(() {
              isDisabled = !isDisabled;
            });
          },
        ),
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
                        child: Text(m.mname),
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
