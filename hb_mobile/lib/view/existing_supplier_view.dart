import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/delete_card.dart';
import 'package:hb_mobile/widgets/search_bar_widget.dart';

// TODO: scroll position to desired position

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
            AppbarDropDownMenu(),
          ],
        ),
        body: ExistingSuppliersList(),
      ),
    );
  }
}

class AppbarDropDownMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (choice) {
        choiceAction(choice, context);
      },
      itemBuilder: (BuildContext context) {
        return SupplierConstants.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  void choiceAction(String choice, BuildContext context) {
    if (choice == SupplierConstants.Settings) {
      print('Settings');
    } else if (choice == SupplierConstants.Refresh) {
      BlocProvider.of<ViewSupplierBloc>(context).add(FetchSupplierEvent());
    } else if (choice == SupplierConstants.AddSupplier) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          kAddSuppliersScreen, ModalRoute.withName(kConfigScreen));
    }
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
    return MultiBlocListener(
      listeners: [
        BlocListener<SupplierBloc, SupplierState>(
          listener: (context, state) {
            if (state is SupplierLoading) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  progressSnackBar(
                      message: state.message,
                      seconds: 1,
                      child: CircularProgressIndicator()),
                );
            }
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
        ),
      ],
      child: BlocBuilder<ViewSupplierBloc, ViewSupplierState>(
        builder: (context, state) {
          if (state is ViewSupplierLoading) {
            return LinearProgressIndicator();
          }
          if (state is ViewSupplierLoaded) {
            final suppliers = state.suppliers;

            return _buildCards(state, suppliers);
          }
          if (state is ViewSupplierError) {
            return _errorMessage(state, context);
          } else {
            return Text('unknown state error please report to developer');
          }
        },
      ),
    );
  }

  Widget _buildCards(ViewSupplierLoaded state, List<Supplier> suppliers) {
    return Column(
      children: [
        SizedBox(height: 8.0),
        SearchBar(
          onChanged: (query) =>
              _viewSupplierBloc.add(SearchAndFetchSupplierEvent(sname: query)),
        ),
        SizedBox(height: 8.0),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1));
              _viewSupplierBloc.add(FetchSupplierEvent());
            },
            child: _buildCardList(state, suppliers),
          ),
        ),
      ],
    );
  }

  Widget _buildCardList(ViewSupplierLoaded state, List<Supplier> suppliers) {
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
    return Padding(
      padding: kCardPadding,
      child: Container(
        decoration: kCardDecoration,
        child: ExpansionTile(
          key: Key("${suppliers[index].scode}"),
          title: _titleCard(context, suppliers, index),
          subtitle: _subtitleCard(suppliers, index),
          children: [
            _addressCard(suppliers, index),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _idCard(suppliers, index),
                    _dateLabel(suppliers, index),
                  ],
                ),
                Row(
                  children: [
                    _editCard(context, suppliers, index),
                    _deleteCard(context, suppliers, index),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _deleteCard(
      BuildContext context, List<Supplier> suppliers, int index) {
    return DeleteCard(
      title: 'Are you sure you want to delete "${suppliers[index].sname}"?',
      actions: [
        FlatButton(
            onPressed: () {
              _editSupplierBloc
                  .add(DeleteSupplier(scode: suppliers[index].scode));
              Navigator.pop(context);
            },
            child: Text('Yes')),
        FlatButton(onPressed: () => Navigator.pop(context), child: Text('No')),
      ],
    );
  }

  IconButton _editCard(
      BuildContext context, List<Supplier> suppliers, int index) {
    return IconButton(
      onPressed: () {
        _showModalBottomSheet(context, suppliers, index);
      },
      icon: Icon(Icons.edit),
    );
  }

  Padding _dateLabel(List<Supplier> suppliers, int index) {
    return Padding(
      padding: kRightPadding,
      child: Text(
        '${suppliers[index].saddate}',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Padding _idCard(List<Supplier> suppliers, int index) {
    return Padding(
      padding: kHorizontalPadding,
      child: Row(
        children: [
          Padding(
            padding: kRightPadding,
            child: Icon(Icons.info),
          ),
          Text('${suppliers[index].scode}'),
        ],
      ),
    );
  }

  Padding _addressCard(List<Supplier> suppliers, int index) {
    return Padding(
      padding: kHorizontalPadding,
      child: Row(
        children: [
          Padding(
            padding: kRightPadding,
            child: Icon(Icons.home),
          ),
          Flexible(
            child: Text(
              '${suppliers[index].saddress}',
            ),
          ),
        ],
      ),
    );
  }

  Row _subtitleCard(List<Supplier> suppliers, int index) {
    return Row(
      children: [
        Row(
          children: [
            Padding(
              padding: kRightPadding,
              child: Icon(
                Icons.call,
                color: kSecondaryColor,
              ),
            ),
            Text('${suppliers[index].snum}'),
          ],
        ),
      ],
    );
  }

  Padding _titleCard(
      BuildContext context, List<Supplier> suppliers, int index) {
    return Padding(
      padding: kBottomPadding,
      child: Row(
        children: [
          Padding(
            padding: kRightPadding,
            child: Icon(
              Icons.account_circle,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text('${suppliers[index].sname}'),
        ],
      ),
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
              child: SupplierBottomSheet(
                viewSupplierBloc: _viewSupplierBloc,
                supplierCode: suppliers[index].scode,
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

  Widget _errorMessage(ViewSupplierError state, BuildContext context) {
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

class SupplierBottomSheet extends StatefulWidget {
  final viewSupplierBloc;
  final String supplierCode;
  final String supplierName;
  final String supplierContact;
  final String supplierAddress;

  const SupplierBottomSheet({
    Key key,
    @required this.supplierCode,
    @required this.supplierName,
    @required this.supplierContact,
    @required this.supplierAddress,
    this.viewSupplierBloc,
  }) : super(key: key);

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<SupplierBottomSheet> {
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
    _supplierCodeController.text = widget.supplierCode;
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
            listener: (context, state) async {
              if (state is SupplierSuccess) {
                await Future.delayed(Duration(seconds: 1));
                widget.viewSupplierBloc.add(FetchSupplierEvent());
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<SupplierBloc, SupplierState>(
              builder: (context, state) {
                if (state is SupplierSuccess) {
                  return message("Value changed successfully");
                }
                if (state is SupplierLoading) {
                  return message(
                    "Updating...",
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is SupplierError) {
                  return _errorMessage(state);
                } else {
                  return _bottomTitle();
                }
              },
            ),
          ),
          _buildCodeField(),
          _buildDateField(),
          _buildNameField(),
          _buildContactField(),
          _buildAddressField(),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Padding _buildActionButtons(BuildContext context) {
    return Padding(
      padding: kPrimaryPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PrimaryActionButton(
            color: Theme.of(context).primaryColor,
            title: 'Change',
            onPressed: () {
              uploadData();
            },
          ),
          PrimaryActionButton(
            title: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
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

  InputField _buildAddressField() {
    return InputField(
      child: TextField(
        minLines: 1,
        maxLines: 2,
        controller: _addressController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Address',
        ),
      ),
      iconData: Icons.home,
    );
  }

  InputField _buildContactField() {
    return InputField(
      child: TextField(
        controller: _contactController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Contact',
        ),
      ),
      iconData: Icons.call,
    );
  }

  InputField _buildNameField() {
    return InputField(
      child: TextField(
        controller: _supplierNameController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Name',
        ),
      ),
      iconData: Icons.person,
    );
  }

  InputField _buildDateField() {
    return InputField(
      child: TextField(
        enabled: false,
        controller: _addDateController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Date',
        ),
      ),
      iconData: Icons.calendar_today,
      isDisabled: true,
    );
  }

  InputField _buildCodeField() {
    return InputField(
      child: TextField(
        enabled: false,
        controller: _supplierCodeController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Supplier code',
        ),
      ),
      iconData: Icons.info,
      isDisabled: true,
    );
  }

  Padding _bottomTitle() {
    return Padding(
      padding: kPrimaryPadding,
      child: Text(
        'Edit Supplier',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }

  Padding _errorMessage(SupplierError state) {
    return Padding(
      padding: kPrimaryPadding,
      child: Text(
        '${state.message}',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
