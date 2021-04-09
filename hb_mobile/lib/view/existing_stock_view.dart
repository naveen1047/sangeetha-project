import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/product_data_table_widget.dart';
import 'package:hb_mobile/widgets/navigate_back_widget.dart';
import 'package:hb_mobile/widgets/search_widget.dart';
import 'package:hb_mobile/widgets/stock_data_table_widget.dart';

class ExistingStocksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              ViewStockDetailsBloc()..add(FetchStocksEvent()),
        ),
        BlocProvider(
          create: (BuildContext context) => StockDetailsBloc(),
        ),
      ],
      child: ExistingStocksList(),
    );
  }
}

class ExistingStocksList extends StatefulWidget {
  @override
  _ExistingStocksListState createState() => _ExistingStocksListState();
}

class _ExistingStocksListState extends State<ExistingStocksList> {
  ViewStockDetailsBloc _viewStockBloc;
  StockDetailsBloc _editStockBloc;

  @override
  void initState() {
    _viewStockBloc = BlocProvider.of<ViewStockDetailsBloc>(context);
    _editStockBloc = BlocProvider.of<StockDetailsBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _viewStockBloc.close();
    _editStockBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Stocks'),
        leading: NavigateBackButton(),
        actions: [
          AppbarDropDownMenu(),
        ],
      ),
      body: BlocListener<StockDetailsBloc, StockDetailsState>(
        listener: (context, state) {
          if (state is StockDetailsSuccess) {
            _viewStockBloc.add(FetchStocksEvent());
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
        child: BlocBuilder<ViewStockDetailsBloc, ViewStockDetailsState>(
          builder: (context, state) {
            if (state is ViewStockDetailsLoading) {
              return LinearProgressIndicator();
            }
            if (state is ViewStockDetailsLoaded) {
              final List<StockDetail> stocks = state.stocks;

              return _buildTable(state, stocks);
            }
            if (state is StockDetailsError) {
              return _errorMessage(state, context);
            } else {
              return Text('unknown state error please report to developer');
            }
          },
        ),
      ),
    );
  }

  Widget _buildTable(ViewStockDetailsLoaded state, List<StockDetail> stocks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Padding(
        //   padding: kTopPadding,
        //   child: SearchWidget(
        //     child: TextField(
        //       style: TextStyle(color: Colors.white),
        //       autofocus: false,
        //       onChanged: (query) => _viewStockBloc.add(Search(pname: query)),
        //       decoration: kSearchTextFieldDecoration,
        //     ),
        //   ),
        // ),
        Expanded(
          child: _buildPaginatedDataTable(state, stocks),
        ),
      ],
    );
  }

  Widget _buildPaginatedDataTable(
      ViewStockDetailsLoaded state, List<StockDetail> stocks) {
    return StockDataTable(
      dataColumn: [
        DataColumn(
            label: datatableLabel("Stock", isSortable: true),
            onSort: (columnIndex, ascending) {
              _viewStockBloc.add(SortStockByPName());
            }),
        DataColumn(
            label: datatableLabel("Last\nStock", isSortable: true),
            numeric: true,
            onSort: (columnIndex, ascending) {
              _viewStockBloc.add(SortStockByLStock());
            }),
        DataColumn(
            label: datatableLabel("Resent\nStock", isSortable: true),
            numeric: true,
            onSort: (columnIndex, ascending) {
              _viewStockBloc.add(SortStockByRStock());
            }),
        DataColumn(
            label: datatableLabel("Total\nStock", isSortable: true),
            numeric: true,
            onSort: (columnIndex, ascending) {
              _viewStockBloc.add(SortStockByTStock());
            }),
        DataColumn(
            label: datatableLabel(
          "Modify / delete",
        )),
      ],
      stocks: stocks,
      viewStockDetailBloc: _viewStockBloc,
      editStockDetailBloc: _editStockBloc,
    );
  }

  Widget _errorMessage(ViewStockDetailsError state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${state.message}'),
          RaisedButton(
              onPressed: () {
                BlocProvider.of<ViewStockDetailsBloc>(context)
                    .add(FetchStocksEvent());
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
        return StockConstants.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  void choiceAction(String choice, BuildContext context) {
    if (choice == StockConstants.Settings) {
      print('Settings');
    } else if (choice == StockConstants.Refresh) {
      BlocProvider.of<ViewStockDetailsBloc>(context).add(FetchStocksEvent());
    }
  }
}
