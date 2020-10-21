import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/delete_card.dart';
import 'package:hb_mobile/widgets/profile_card.dart';
import 'package:hb_mobile/widgets/search_bar_widget.dart';
import 'package:hb_mobile/widgets/supplier_bottom_sheet_widget.dart';

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
    return ProfileCard(
      cardKey: "${suppliers[index].scode}",
      title: "${suppliers[index].sname}",
      subtitle: "${suppliers[index].snum}",
      date: "${suppliers[index].saddate}",
      id: "${suppliers[index].scode}",
      detail: "${suppliers[index].saddress}",
      editCard: _editCard(context, suppliers, index),
      deleteCard: _deleteCard(context, suppliers, index),
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
