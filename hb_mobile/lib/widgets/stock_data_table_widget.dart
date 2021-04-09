import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/product_bottom_sheet_widget.dart';
import 'package:hb_mobile/widgets/stock_bottom_sheet_widget.dart';

class StockDataTable extends StatelessWidget {
  final List<DataColumn> dataColumn;
  final List<StockDetail> stocks;
  final ViewStockDetailsBloc viewStockDetailBloc;
  final StockDetailsBloc editStockDetailBloc;

  const StockDataTable(
      {Key key,
      this.dataColumn,
      this.stocks,
      this.viewStockDetailBloc,
      this.editStockDetailBloc})
      : super(key: key);

  Widget build(BuildContext context) {
    final bool isEmpty = stocks.length < 1;

    return Padding(
      padding: kPrimaryPadding,
      child: ListView(
        children: [
          PaginatedDataTable(
            columnSpacing: 10,
            header: Text(isEmpty ? 'No result found' : 'StockDetail'),
            rowsPerPage: isEmpty ? 1 : 6,
            columns: dataColumn,
            source: _DataSource(
                context, stocks, viewStockDetailBloc, editStockDetailBloc),
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
    this.valueStockDetail,
  );

  final String valueA;
  final String valueB;
  final String valueC;
  final String valueD;
  final StockDetail valueStockDetail;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this.stocks, this._viewStockDetailBloc,
      this._editStockDetailBloc) {
    _rows = stocks
        .map((data) =>
            _Row(data.pname, data.cstock, data.rstock, data.tstock, data))
        .toList();
  }

  final BuildContext context;
  List<_Row> _rows;
  List<StockDetail> stocks;
  ViewStockDetailsBloc _viewStockDetailBloc;
  StockDetailsBloc _editStockDetailBloc;

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
        // TODO: it can be repaced by this for smaller text
        // dataCellDecorator(row.valueA),
        // dataCellDecorator(row.valueB),
        // dataCellDecorator(row.valueC),
        // dataCellDecorator(row.valueD),
        // dataCellDecorator(row.valueE),
        // dataCellDecorator(row.valueF),
        // dataCellDecorator(row.valueG),
        _modifyDataCell(row.valueStockDetail),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  DataCell _modifyDataCell(StockDetail data) {
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
        ],
      ),
    );
  }

  Future<void> _showModalBottomSheet(BuildContext context, StockDetail data) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: BlocProvider(
              create: (BuildContext context) => StockDetailsBloc(),
              child: StockDetailBottomSheet(
                viewStockDetailBloc: _viewStockDetailBloc,
                pcode: data.pcode,
                pName: data.pname,
                lStock: data.cstock,
                tStock: data.tstock,
                rStock: data.rstock,
              ),
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }
}
