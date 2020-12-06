import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/product_bottom_sheet_widget.dart';

class ProductDataTable extends StatelessWidget {
  final List<DataColumn> dataColumn;
  final List<Product> products;
  final ViewProductBloc viewProductBloc;
  final ProductBloc editProductBloc;

  const ProductDataTable(
      {Key key,
      this.dataColumn,
      this.products,
      this.viewProductBloc,
      this.editProductBloc})
      : super(key: key);

  Widget build(BuildContext context) {
    final bool isEmpty = products.length < 1;

    return Padding(
      padding: kPrimaryPadding,
      child: ListView(
        children: [
          PaginatedDataTable(
            columnSpacing: 10,
            header: Text(isEmpty ? 'No result found' : 'Product'),
            rowsPerPage: isEmpty ? 1 : 6,
            columns: dataColumn,
            source: _DataSource(
                context, products, viewProductBloc, editProductBloc),
          ),
        ],
      ),
    );
  }
}

class _Row {
  _Row(
    this.valueA,
    this.valueB,
    this.valueC,
    this.valueD,
    this.valueE,
    this.valueF,
    this.valueG,
    this.valueProduct,
  );

  final String valueA;
  final String valueB;
  final String valueC;
  final String valueD;
  final String valueE;
  final String valueF;
  final String valueG;
  final Product valueProduct;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this.products, this._viewProductBloc,
      this._editProductBloc) {
    _rows = products
        .map((data) => _Row(data.pname, data.pcode, data.salaryps,
            data.nospsunit, data.sunit, data.pricepersunit, data.nosps, data))
        .toList();
  }

  final BuildContext context;
  List<_Row> _rows;
  List<Product> products;
  ViewProductBloc _viewProductBloc;
  ProductBloc _editProductBloc;

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Container(
          width: 130,
          child: Text(
            row.valueA,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        )),
        DataCell(Text(
          row.valueB,
          style: TextStyle(color: Colors.grey),
        )),
        DataCell(
          Text(row.valueC),
        ),
        DataCell(Text(
          row.valueD,
        )),
        DataCell(
          Text(
            row.valueE,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        DataCell(Text(row.valueF)),
        DataCell(Text(row.valueG)),
        // TODO: it can be repaced by this for smaller text
        // dataCellDecorator(row.valueA),
        // dataCellDecorator(row.valueB),
        // dataCellDecorator(row.valueC),
        // dataCellDecorator(row.valueD),
        // dataCellDecorator(row.valueE),
        // dataCellDecorator(row.valueF),
        // dataCellDecorator(row.valueG),
        _modifyDataCell(row.valueProduct),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  DataCell _modifyDataCell(Product data) {
    return DataCell(
      Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.edit,
              // color: kPrimaryAccentColor,
            ),
            onPressed: () {
              _showModalBottomSheet(context, data);
            },
          ),
          IconButton(
              icon: Icon(
                Icons.delete,
                // color: kPrimaryColor,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(
                      'Are you sure you want to delete "${data.pname}"?',
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            _editProductBloc
                                .add(DeleteProduct(pcode: data.pcode));
                            Navigator.pop(context);
                          },
                          child: Text('Yes')),
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('No')),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  Future<void> _showModalBottomSheet(BuildContext context, Product data) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: BlocProvider(
              create: (BuildContext context) => ProductBloc(),
              child: ProductBottomSheet(
                viewProductBloc: _viewProductBloc,
                productName: data.pname,
                productCode: data.pcode,
                pricePerSellingUnit: data.pricepersunit,
                salaryPerStroke: data.salaryps,
                unitPerStroke: data.nospsunit,
                unitsPerSellingUnit: data.nosps,
                sellingUnit: data.sunit,
              ),
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }
}
