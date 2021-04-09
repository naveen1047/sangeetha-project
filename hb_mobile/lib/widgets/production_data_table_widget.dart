import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';

class ProductionDataTable extends StatelessWidget {
  final List<DataColumn> dataColumn;
  final List<Production> productions;
  final ViewProductionBloc viewProductionBloc;
  final ProductionEntryBloc editProductionBloc;

  const ProductionDataTable(
      {Key key,
      this.dataColumn,
      this.productions,
      this.viewProductionBloc,
      this.editProductionBloc})
      : super(key: key);

  Widget build(BuildContext context) {
    final bool isEmpty = productions.length < 1;

    return Padding(
      padding: kPrimaryPadding,
      child: ListView(
        children: [
          PaginatedDataTable(
            columnSpacing: 10,
            header: isEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text('No result found'),
                        IconButton(
                            onPressed: () {
                              viewProductionBloc.add(FetchProductionEvent());
                            },
                            icon: Icon(Icons.refresh))
                      ],
                    ),
                  )
                : Text('Production'),
            rowsPerPage: isEmpty ? 1 : 6,
            columns: dataColumn,
            source: _DataSource(
                context, productions, viewProductionBloc, editProductionBloc),
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
    this.valueProduction,
  );

  final String valueA;
  final String valueB;
  final String valueC;
  final String valueD;
  final String valueE;
  final String valueF;
  final String valueG;
  final Production valueProduction;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this.productions, this._viewProductionBloc,
      this._editProductionBloc) {
    _rows = productions
        .map((data) => _Row(data.date, data.pname, data.ename, data.sps,
            data.nos, data.salary, data.remarks, data))
        .toList();
  }

  final BuildContext context;
  List<_Row> _rows;
  List<Production> productions;
  ViewProductionBloc _viewProductionBloc;
  ProductionEntryBloc _editProductionBloc;

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
        _modifyDataCell(row.valueProduction),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  DataCell _modifyDataCell(Production data) {
    return DataCell(
      Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.edit,
              // color: kPrimaryAccentColor,
            ),
            onPressed: () async {
              print("edit");
              final dynamic res = await Navigator.pushNamed(
                  context, kEditProductionScreen,
                  arguments: data);
              if (res[1] == true) {
                _viewProductionBloc.add(FetchProductionEvent());
              }
              print(res.runtimeType.toString());

              // _showModalBottomSheet(context, data);
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
                      'Are you sure you want to delete "${data.pcode}"?',
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            _editProductionBloc
                                .add(DeleteProduction(data.pdcode));
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

// TODO: create new screen for edit

// Future<void> _showModalBottomSheet(BuildContext context, Production data) {
//   return showModalBottomSheet<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom),
//           child: BlocProvider(
//             create: (BuildContext context) => ProductionEntryBloc(),
//             child: ProductionBottomSheet(
//               viewProductionBloc: _viewProductionBloc,
//               productionName: data.pname,
//               productionCode: data.pcode,
//               pricePerSellingUnit: data.pricepersunit,
//               salaryPerStroke: data.salaryps,
//               unitPerStroke: data.nospsunit,
//               unitsPerSellingUnit: data.nosps,
//               sellingUnit: data.sunit,
//             ),
//           ),
//         ),
//       );
//     },
//     isScrollControlled: true,
//   );
// }
}
