import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class ExistingSuppliersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              ViewSupplierBloc()..add(FetchSupplierEvent()),
        ),
        BlocProvider(
          create: (BuildContext context) => SupplierBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Existing Suppliers'),
          actions: [
            AppBarAction(),
          ],
        ),
        body: ExistingSuppliersList(),
      ),
    );
  }
}

class AppBarAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.refresh),
      onPressed: () =>
          BlocProvider.of<ViewSupplierBloc>(context).add(FetchSupplierEvent()),
    );
  }
}

class ExistingSuppliersList extends StatefulWidget {
  @override
  _ExistingSuppliersListState createState() => _ExistingSuppliersListState();
}

class _ExistingSuppliersListState extends State<ExistingSuppliersList> {
  ViewSupplierBloc _viewSupplierBloc;
  SupplierBloc _editSupplierBloc;

  @override
  void initState() {
    _viewSupplierBloc = BlocProvider.of<ViewSupplierBloc>(context);
    _editSupplierBloc = BlocProvider.of<SupplierBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _viewSupplierBloc.close();
    _editSupplierBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SupplierBloc, SupplierState>(
      listener: (context, state) {
        if (state is SupplierSuccess) {
          _viewSupplierBloc.add(FetchSupplierEvent());
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  '${state.message}',
                  softWrap: true,
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<ViewSupplierBloc, ViewSupplierState>(
        builder: (context, state) {
          if (state is SupplierLoadingState) {
            return LinearProgressIndicator();
          }
          if (state is SupplierLoadedState) {
            final suppliers = state.suppliers;

            return _buildCards(state, suppliers);
          }
          if (state is SupplierErrorState) {
            return _errorMessage(state, context);
          } else {
            return Text('unknown state error please report to developer');
          }
        },
      ),
    );
  }

  Widget _buildCards(SupplierLoadedState state, List<Supplier> suppliers) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (query) => _viewSupplierBloc
                .add(SearchAndFetchSupplierEvent(sname: query)),
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Search suppliers'),
          ),
        ),
        Expanded(
          child: _buildCardList(state, suppliers),
        ),
      ],
    );
  }

  Widget _buildCardList(SupplierLoadedState state, List<Supplier> suppliers) {
    if (suppliers.length == 0) {
      return Center(child: Text("no results found"));
    }
    return ListView.builder(
      itemCount: state.suppliers.length,
      itemBuilder: (context, index) {
        return _buildCard(suppliers, index, context);
      },
    );
  }

  Widget _buildCard(List<Supplier> suppliers, int index, BuildContext context) {
    return ExpansionTile(
      title: Text('${suppliers[index].sname}'),
      subtitle: Text('${suppliers[index].snum}'),
      trailing: Text('${suppliers[index].saddate}'),
      children: [
        Row(
          children: [
            Padding(
              padding: kHorizontalPadding,
              child: Text('${suppliers[index].saddress}'),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: kHorizontalPadding,
              child: Text('${suppliers[index].scode}'),
            ),
            IconButton(
              onPressed: () {
                _showModalBottomSheet(context, suppliers, index);
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(
                      'Are you sure you want to delete "${suppliers[index].sname}"?',
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            _editSupplierBloc.add(
                                DeleteSupplier(scode: suppliers[index].scode));
                            Navigator.pop(context);
                          },
                          child: Text('Yes')),
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('No')),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showModalBottomSheet(
      BuildContext context, List<Supplier> suppliers, int index) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: BlocProvider(
              create: (BuildContext context) => SupplierBloc(),
              child: BottomSheet(
                viewSupplierBloc: _viewSupplierBloc,
                suppliercode: suppliers[index].scode,
                supplierContact: suppliers[index].snum,
                supplierName: suppliers[index].sname,
                supplierAddress: suppliers[index].saddress,
              ),
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  Widget _errorMessage(SupplierErrorState state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${state.message}'),
          RaisedButton(
              onPressed: () {
                BlocProvider.of<ViewSupplierBloc>(context)
                    .add(FetchSupplierEvent());
              },
              child: Text('refresh')),
        ],
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  final viewSupplierBloc;
  final String suppliercode;
  final String supplierName;
  final String supplierContact;
  final String supplierAddress;

  const BottomSheet({
    Key key,
    @required this.suppliercode,
    @required this.supplierName,
    @required this.supplierContact,
    @required this.supplierAddress,
    this.viewSupplierBloc,
  }) : super(key: key);

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  SupplierBloc _addSupplierBloc;
  TextEditingController _supplierNameController;
  TextEditingController _supplierCodeController;
  TextEditingController _contactController;
  TextEditingController _addressController;
  TextEditingController _addDateController;

  @override
  void initState() {
    _addSupplierBloc = BlocProvider.of<SupplierBloc>(context);
    _supplierNameController = TextEditingController();
    _supplierCodeController = TextEditingController();
    _contactController = TextEditingController();
    _addressController = TextEditingController();
    _addDateController = TextEditingController();
    setValues();
    super.initState();
  }

  void setValues() {
    _supplierCodeController.text = widget.suppliercode;
    _supplierNameController.text = widget.supplierName;
    _contactController.text = widget.supplierContact;
    _addressController.text = widget.supplierAddress;
    _addDateController.text = _addSupplierBloc.getDateInFormat;
  }

  @override
  void dispose() {
    _supplierNameController.dispose();
    _supplierCodeController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _addDateController.dispose();
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
          BlocListener<SupplierBloc, SupplierState>(
            listener: (context, state) {
              if (state is SupplierSuccess) {
                widget.viewSupplierBloc.add(FetchSupplierEvent());
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<SupplierBloc, SupplierState>(
              builder: (context, state) {
                if (state is SupplierError) {
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
                    child: Text('Edit Supplier'),
                  );
                }
              },
            ),
          ),
          InputField(
            textField: TextField(
              enabled: false,
              controller: _supplierCodeController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Supplier code',
              ),
            ),
            iconData: Icons.info,
            isDisabled: true,
          ),
          InputField(
            textField: TextField(
              enabled: false,
              controller: _addDateController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Date',
              ),
            ),
            iconData: Icons.calendar_today,
            isDisabled: true,
          ),
          InputField(
            textField: TextField(
              controller: _supplierNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Name',
              ),
            ),
            iconData: Icons.person,
          ),
          InputField(
            textField: TextField(
              controller: _contactController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Contact',
              ),
            ),
            iconData: Icons.call,
          ),
          InputField(
            textField: TextField(
              minLines: 1,
              maxLines: 2,
              controller: _addressController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Address',
              ),
            ),
            iconData: Icons.home,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PrimaryActionButton(
                  title: 'Change',
                  onPressed: () {
                    uploadData();
                  },
                ),
                RaisedButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void uploadData() {
    _addSupplierBloc
      ..add(
        EditSupplier(
          sname: _supplierNameController.text,
          saddate: _addDateController.text,
          saddress: _addressController.text,
          scode: _supplierCodeController.text,
          snum: _contactController.text,
        ),
      );
  }
}
