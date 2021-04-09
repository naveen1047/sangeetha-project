import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/product_data_table_widget.dart';
import 'package:hb_mobile/widgets/navigate_back_widget.dart';
import 'package:hb_mobile/widgets/production_data_table_widget.dart';
import 'package:hb_mobile/widgets/search_widget.dart';

class ExistingProductionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              ViewProductionBloc()..add(FetchProductionEvent()),
        ),
        BlocProvider(
          create: (BuildContext context) => ProductionEntryBloc(),
        ),
      ],
      child: ExistingProductionsList(),
    );
  }
}

class ExistingProductionsList extends StatefulWidget {
  @override
  _ExistingProductionsListState createState() =>
      _ExistingProductionsListState();
}

class _ExistingProductionsListState extends State<ExistingProductionsList> {
  ViewProductionBloc _viewProductionBloc;
  ProductionEntryBloc _editProductionEntryBloc;

  @override
  void initState() {
    _viewProductionBloc = BlocProvider.of<ViewProductionBloc>(context);
    _editProductionEntryBloc = BlocProvider.of<ProductionEntryBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _viewProductionBloc.close();
    _editProductionEntryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Productions'),
        leading: NavigateBackButton(),
        actions: [
          AppbarDropDownMenu(),
        ],
      ),
      body: BlocListener<ProductionEntryBloc, ProductionEntryState>(
        listener: (context, state) {
          if (state is ProductionEntrySuccess) {
            _viewProductionBloc.add(FetchProductionEvent());
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
        child: BlocBuilder<ViewProductionBloc, ViewProductionState>(
          builder: (context, state) {
            if (state is ViewProductionLoadingState) {
              return LinearProgressIndicator();
            }
            if (state is ViewProductionLoadedState) {
              final List<Production> production = state.production;

              return _buildTable(state, production);
            }
            if (state is ViewProductionErrorState) {
              return _errorMessage(state, context);
            } else {
              return Text('unknown state error please report to developer');
            }
          },
        ),
      ),
    );
  }

  Widget _buildTable(
      ViewProductionLoadedState state, List<Production> productions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: kTopPadding,
          child: SearchWidget(
            child: TextField(
              style: TextStyle(color: Colors.white),
              autofocus: false,
              onChanged: (query) => _viewProductionBloc
                  .add(SearchAndFetchProductionEvent(ename: query)),
              decoration: kSearchTextFieldDecoration,
            ),
          ),
        ),
        Expanded(
          child: _buildPaginatedDataTable(state, productions),
        ),
      ],
    );
  }

  Widget _buildPaginatedDataTable(
      ViewProductionLoadedState state, List<Production> production) {
    return ProductionDataTable(
      dataColumn: [
        DataColumn(
            label: datatableLabel("Date", isSortable: true),
            onSort: (columnIndex, ascending) {
              _viewProductionBloc.add(SortProductionByDate());
            }),
        DataColumn(
            label: datatableLabel("Product", isSortable: true),
            onSort: (columnIndex, ascending) {
              _viewProductionBloc.add(SortProductionByPName());
            }),
        DataColumn(
            label: datatableLabel("Team", isSortable: true),
            numeric: true,
            onSort: (columnIndex, ascending) {
              _viewProductionBloc.add(SortProductionByEName());
            }),
        DataColumn(
            label: datatableLabel("Salary Per\nStroke", isSortable: true),
            numeric: true,
            onSort: (columnIndex, ascending) {
              _viewProductionBloc.add(SortProductionBySalaryPS());
            }),
        DataColumn(
            label: datatableLabel("No of Strokes", isSortable: true),
            onSort: (columnIndex, ascending) {
              _viewProductionBloc.add(SortProductionByNoOfS());
            }),
        DataColumn(
            label: datatableLabel("Salary", isSortable: true),
            numeric: true,
            onSort: (columnIndex, ascending) {
              _viewProductionBloc.add(SortProductionBySalary());
            }),
        DataColumn(
          label: datatableLabel("Remarks", isSortable: false),
          numeric: true,
        ),
        DataColumn(
            label: datatableLabel(
          "Modify / delete",
        )),
      ],
      productions: production,
      viewProductionBloc: _viewProductionBloc,
      editProductionBloc: _editProductionEntryBloc,
    );
  }

  Widget _errorMessage(ViewProductionErrorState state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${state.message}'),
          RaisedButton(
              onPressed: () {
                BlocProvider.of<ViewProductionBloc>(context)
                    .add(FetchProductionEvent());
              },
              child: Text('refresh')),
        ],
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
        return ProductConstants.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  void choiceAction(String choice, BuildContext context) {
    if (choice == ProductionConstants.Settings) {
      print('Settings');
    } else if (choice == ProductionConstants.Refresh) {
      BlocProvider.of<ViewProductionBloc>(context).add(FetchProductionEvent());
    } else if (choice == ProductionConstants.AddProduction) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          kAddProductionScreen, ModalRoute.withName(kConfigScreen));
    }
  }
}
