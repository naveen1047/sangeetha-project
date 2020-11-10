import 'package:core/core.dart';
// import 'package:core/src/business_logics/bloc/product_bloc/product_bloc.dart'
// as productBloc;
import 'package:core/src/business_logics/models/product.dart' as product;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/product_data_table_widget.dart';
import 'package:hb_mobile/widgets/navigate_back_widget.dart';
import 'package:hb_mobile/widgets/search_widget.dart';

class ExistingProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              ViewProductBloc()..add(FetchProductEvent()),
        ),
        BlocProvider(
          create: (BuildContext context) => ProductBloc(),
        ),
      ],
      child: ExistingProductsList(),
    );
  }
}

class ExistingProductsList extends StatefulWidget {
  @override
  _ExistingProductsListState createState() => _ExistingProductsListState();
}

class _ExistingProductsListState extends State<ExistingProductsList> {
  ViewProductBloc _viewProductBloc;
  ProductBloc _editProductBloc;

  @override
  void initState() {
    _viewProductBloc = BlocProvider.of<ViewProductBloc>(context);
    _editProductBloc = BlocProvider.of<ProductBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _viewProductBloc.close();
    _editProductBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Products'),
        leading: NavigateBackButton(),
        actions: [
          AppbarDropDownMenu(),
        ],
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductSuccess) {
            _viewProductBloc.add(FetchProductEvent());
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
        child: BlocBuilder<ViewProductBloc, ViewProductState>(
          builder: (context, state) {
            if (state is ProductLoadingState) {
              return LinearProgressIndicator();
            }
            if (state is ProductLoadedState) {
              final List<product.Product> products = state.products;

              return _buildTable(state, products);
            }
            if (state is ProductErrorState) {
              return _errorMessage(state, context);
            } else {
              return Text('unknown state error please report to developer');
            }
          },
        ),
      ),
    );
  }

  Widget _buildTable(ProductLoadedState state, List<product.Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: kTopPadding,
          child: SearchWidget(
            child: TextField(
              style: TextStyle(color: Colors.white),
              autofocus: false,
              // onChanged: (query) => _viewProductBloc
              //     .add(SearchAndFetchProductEvent(mname: query)),
              decoration: kSearchTextFieldDecoration,
            ),
          ),
        ),
        Expanded(
          child: _buildPaginatedDataTable(state, products),
        ),
      ],
    );
  }

  Widget _buildPaginatedDataTable(
      ProductLoadedState state, List<product.Product> products) {
    return ProductDataTable(
      dataColumn: [
        DataColumn(
            label: datatableLabel("Product", isSortable: true),
            onSort: (columnIndex, ascending) {
              _viewProductBloc.add(SortProductByName());
            }),
        DataColumn(
            label: datatableLabel("Code", isSortable: false),
            numeric: true,
            onSort: (columnIndex, ascending) {
              _viewProductBloc.add(SortProductByUnit());
            }),
        DataColumn(
            label: datatableLabel("Salary per Stroke", isSortable: true),
            numeric: true,
            onSort: (columnIndex, ascending) {
              _viewProductBloc.add(SortProductByPrice());
            }),
        DataColumn(
            label: datatableLabel("Nos produced per stroke", isSortable: true),
            numeric: true,
            onSort: (columnIndex, ascending) {
              _viewProductBloc.add(SortProductByPrice());
            }),
        DataColumn(
            label: datatableLabel("Selling unit", isSortable: true),
            numeric: true,
            onSort: (columnIndex, ascending) {
              _viewProductBloc.add(SortProductByPrice());
            }),
        DataColumn(
            label: datatableLabel("price per selling unit", isSortable: true),
            numeric: true,
            onSort: (columnIndex, ascending) {
              _viewProductBloc.add(SortProductByPrice());
            }),
        DataColumn(
            label: datatableLabel("Nos per selling unit", isSortable: true),
            numeric: true,
            onSort: (columnIndex, ascending) {
              _viewProductBloc.add(SortProductByPrice());
            }),
        DataColumn(
            label: datatableLabel(
          "Modify / delete",
        )),
      ],
      products: products,
      viewProductBloc: _viewProductBloc,
      editProductBloc: _editProductBloc,
    );
  }

  Widget _errorMessage(ProductErrorState state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${state.message}'),
          RaisedButton(
              onPressed: () {
                BlocProvider.of<ViewProductBloc>(context)
                    .add(FetchProductEvent());
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
    if (choice == ProductConstants.Settings) {
      print('Settings');
    } else if (choice == ProductConstants.Refresh) {
      BlocProvider.of<ViewProductBloc>(context).add(FetchProductEvent());
    } else if (choice == ProductConstants.AddProduct) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          kAddProductScreen, ModalRoute.withName(kConfigScreen));
    }
  }
}
