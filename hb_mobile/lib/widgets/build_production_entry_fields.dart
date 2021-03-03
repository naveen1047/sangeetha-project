import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:core/core.dart';

import '../constant.dart';

class BuildProductionEntryFields extends StatefulWidget {
  final List<Product> products;
  final List<Employee> employees;
  final bool isEditable;
  final Production p;

  const BuildProductionEntryFields({
    Key key,
    this.products,
    this.employees,
    this.isEditable = false,
    this.p,
  }) : super(key: key);

  @override
  _BuildProductionEntryFieldsState createState() =>
      _BuildProductionEntryFieldsState(products, employees);
}

class _BuildProductionEntryFieldsState
    extends State<BuildProductionEntryFields> {
  int noOfStroke = 0;
  int unitProducedPerStroke = 0;
  int total = 0;
  bool isSpsChanged = false;

  ProductionEntryBloc _productionEntryBloc;
  List<Product> products;
  List<Employee> employees;
  TextEditingController _salaryPerStrokeController;
  TextEditingController _unitsProducedPerStrokeController;
  TextEditingController _noOfStrokeController;
  TextEditingController _salaryController;
  TextEditingController _remarksController;
  TextEditingController _dateController;
  Production p;

  _BuildProductionEntryFieldsState(
      List<Product> products, List<Employee> employees) {
    this.products = products;
    this.employees = employees;
  }

  String selectedProduct;
  String selectedEmployees;
  bool isNospsDisabled = true;
  bool isSpsDisabled = true;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    _productionEntryBloc = BlocProvider.of<ProductionEntryBloc>(context);

    _salaryPerStrokeController = TextEditingController();
    _unitsProducedPerStrokeController = TextEditingController();
    _noOfStrokeController = TextEditingController();
    _salaryController = TextEditingController();
    _remarksController = TextEditingController();
    _dateController = TextEditingController();
    _dateController.text = selectedDate.toString();

    _noOfStrokeController.text = '0';

    if (widget.isEditable) {
      selectedDate = DateTime.parse(widget.p.date);
      context.bloc<DatePickerCubit>().selectDate(selectedDate);

      _salaryPerStrokeController.text = widget.p.sps;
      _unitsProducedPerStrokeController.text = widget.p.nosps;
      _noOfStrokeController.text = widget.p.nos;
      _salaryController.text = widget.p.salary;
      _remarksController.text = widget.p.remarks;
      _dateController.text = widget.p.date;

      selectedProduct = widget.p.pcode;
      selectedEmployees = widget.p.ecode;

      // calculatePrice(widget.p.unitprice, widget.p.quantity);
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
    _salaryPerStrokeController.dispose();
    _unitsProducedPerStrokeController.dispose();
    _noOfStrokeController.dispose();
    _salaryController.dispose();
    _remarksController.dispose();
    _dateController.dispose();
    _productionEntryBloc.close();
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
          _datePicker(context),
          _productDropdown(),
          _teamDropdown(context),
          _salaryPerStroke(),
          _unitProducedPerStroke(context),

          _noOfStroke(context),
          Container(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              "Current Stock: "
              "$unitProducedPerStroke X $noOfStroke",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ),
          ),
          // _totalPrice(),
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

  TextFormField _noOfStroke(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _noOfStrokeController,
      onChanged: (str) {
        setState(() {
          // TODO: add decimal point exception
          noOfStroke = int.parse(str);
        });
      },
      // onChanged: (text) {
      //   double q;
      //   if (text != null && text != "") {
      //     q = double.parse(text);
      //   } else {
      //     q = 0.0;
      //   }
      //   context.bloc<TotalPriceCubit>().setQuantity(q);
      // },
      maxLength: 10,
      decoration: InputDecoration(
        icon: Icon(Icons.repeat),
        labelText: 'Number of Strokes',

        // helperText: '',
        enabledBorder: UnderlineInputBorder(),
      ),
    );
  }

  BlocBuilder<TotalPriceCubit, double> _totalPrice() {
    return BlocBuilder<TotalPriceCubit, double>(
      builder: (BuildContext context, state) {
        _salaryController.text = '$state';
        return TextFormField(
          keyboardType: TextInputType.number,
          controller: _salaryController,
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

  Widget _unitProducedPerStroke(BuildContext context) {
    return BlocBuilder<ProductionWorkerCubit, ProductionWorker>(
      builder: (BuildContext context, state) {
        if (_unitsProducedPerStrokeController.text == '') {
          String upps = state.nosps.toString();
          print(upps);
          _unitsProducedPerStrokeController.text = upps;
          unitProducedPerStroke = int.parse(upps);
        }

        return Padding(
          padding: kTopPadding,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _unitsProducedPerStrokeController,
                  onChanged: (str) {
                    setState(() {
                      unitProducedPerStroke = int.parse(str);
                    });
                  },
                  enabled: !isNospsDisabled,
                  // onChanged: (text) {
                  //   double p;
                  //   print("a");
                  //   if (text != null && text != "") {
                  //     p = double.parse(text);
                  //   } else {
                  //     p = 0.0;
                  //   }
                  //   context.bloc<TotalPriceCubit>().setPrice(p);
                  // },
                  maxLength: 10,
                  decoration: InputDecoration(
                    icon: Icon(Icons.storage),
                    labelText: 'Units produced per stroke',

                    // helperText: '',
                    enabledBorder: UnderlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    isNospsDisabled = !isNospsDisabled;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  BlocBuilder<ProductionWorkerCubit, ProductionWorker> _salaryPerStroke() {
    return BlocBuilder<ProductionWorkerCubit, ProductionWorker>(
      builder: (BuildContext context, state) {
        // if (_salaryPerStrokeController.text == null) {
        if (!isSpsChanged) {
          _salaryPerStrokeController.text = state.sps.toString();
          isSpsChanged = false;
        }
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (text) {
                  isSpsChanged = true;
                },
                keyboardType: TextInputType.numberWithOptions(),
                maxLength: 20,
                enabled: !isSpsDisabled,
                decoration: InputDecoration(
                  icon: rupee,
                  labelText: 'Salary per Stroke',
                  // helperText: '',
                  enabledBorder: UnderlineInputBorder(),
                ),
                controller: _salaryPerStrokeController,
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isSpsDisabled = !isSpsDisabled;
                });
              },
            ),
          ],
        );
        // return TextFormField(
        //   keyboardType: TextInputType.number,
        //   controller: _totalPriceController,
        //   maxLength: 12,
        //   decoration: InputDecoration(
        //     icon: rupee,
        //     labelText: 'Total price',
        //
        //     // helperText: '',
        //     enabledBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(),
        //     ),
        //   ),
        // );
      },
    );
  }

  // TextFormField _salaryPerStroke() {
  //   return TextFormField(
  //     maxLength: 20,
  //     enabled: !widget.isEditable,
  //     decoration: InputDecoration(
  //       icon: rupee,
  //       labelText: 'Salary per Stroke',
  //       // helperText: '',
  //       enabledBorder: UnderlineInputBorder(),
  //     ),
  //     controller: _salaryPerStrokeController,
  //   );
  // }

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
          widget.isEditable ? editData() : uploadData();
        },
      ),
    );
  }

  Widget _teamDropdown(BuildContext context) {
    return Padding(
      padding: kTopPadding,
      child: Row(
        children: [
          Padding(
            padding: kRightPadding,
            child: Icon(Icons.people),
          ),
          Expanded(
            child: Padding(
              padding: kLeftPadding,
              child: DropdownButtonHideUnderline(
                child: DropdownDecorator(
                  child: DropdownButton<String>(
                    hint: Text("Select Team"),
                    value: selectedEmployees,
                    onChanged: (String newValue) {
                      setState(() {
                        selectedEmployees = newValue;
                        var employee = employees.where(
                            (element) => element.ecode == selectedEmployees);
                        // _noOfStrokeController.text =
                        //     material.first.mpriceperunit.toString();
                        // context.bloc<TotalPriceCubit>().setPrice(
                        //     double.parse(material.first.mpriceperunit));
                      });
                      print(selectedEmployees);
                    },
                    items: employees.map((Employee e) {
                      return DropdownMenuItem<String>(
                        value: e.ecode,
                        child: Text('${e.ename} - ${e.ecode}'),
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

  void uploadData() {
    print(selectedProduct);
    _productionEntryBloc.add(ProductionEntry(
      sps: _salaryPerStrokeController.text,
      pcode: selectedProduct,
      // pdcode: _,
      date: _dateController.text,
      // billno: _salaryPerStrokeController.text,
      ecode: selectedEmployees,
      nosps: _unitsProducedPerStrokeController.text,
      nos: _noOfStrokeController.text,
      salary: _salaryController.text,
      remarks: _remarksController.text,
    ));
  }

  Widget _productDropdown() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: kRightPadding,
          child: Icon(Icons.notes),
        ),
        Expanded(
          child: Padding(
            padding: kLeftPadding,
            child: DropdownButtonHideUnderline(
              child: DropdownDecorator(
                child: DropdownButton<String>(
                  hint: Text("Select Product"),
                  value: selectedProduct,
                  onChanged: (String newValue) {
                    // if (p.length > 0) {
                    //   context
                    //       .bloc<ProductionWorkerCubit>()
                    //       .selectProduct(p.first.salaryps, p.first.nosps);
                    // }

                    // To check whether sps text is changed
                    isSpsChanged = false;
                    setState(() {
                      selectedProduct = newValue;
                    });
                    Product p = products
                        .where((element) => element.pcode == selectedProduct)
                        .first;
                    print(p.pcode);

                    // _salaryPerStrokeController.text = null;
                    // print("set null");
                    context
                        .bloc<ProductionWorkerCubit>()
                        .selectProduct(p.salaryps, p.nosps);
                  },
                  items: products.map((Product p) {
                    return DropdownMenuItem<String>(
                      value: p.pcode,
                      child: Text(p.pname),
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

  void editData() {
    print(selectedProduct);
    _productionEntryBloc.add(EditProduction(
      sps: _salaryPerStrokeController.text,
      pcode: selectedProduct,
      // pdcode: _,
      date: _dateController.text,
      // billno: _salaryPerStrokeController.text,
      ecode: selectedEmployees,
      nosps: _unitsProducedPerStrokeController.text,
      nos: _noOfStrokeController.text,
      salary: _salaryController.text,
      remarks: _remarksController.text,
    ));
  }
}
