import 'package:core/core.dart';
import 'package:flutter/material.dart';
// import 'package:core/src/business_logics/models/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/material_bottom_sheet_widget.dart';

class MPDataTable extends StatelessWidget {
  final List<DataColumn> dataColumn;
  final List<MaterialPurchase> mps;
  final ViewMPBloc viewMPBloc;
  final MPBloc editMPBloc;

  const MPDataTable(
      {Key key, this.dataColumn, this.mps, this.viewMPBloc, this.editMPBloc})
      : super(key: key);

  Widget build(BuildContext context) {
    final bool isEmpty = mps.length < 1;

    return Padding(
      padding: kPrimaryPadding,
      child: ListView(
        children: [
          PaginatedDataTable(
            columnSpacing: 10,
            header: Text(isEmpty ? 'No result found' : 'MP'),
            rowsPerPage: isEmpty ? 1 : 6,
            columns: dataColumn,
            source: _DataSource(
              context,
              mps,
              viewMPBloc, /*editMPBloc*/
            ),
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
    this.valueH,
    this.mp,
  );

  final String valueA;
  final String valueB;
  final String valueC;
  final String valueD;
  final String valueE;
  final String valueF;
  final String valueG;
  final String valueH;
  final MaterialPurchase mp;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  _DataSource(
    this.context,
    this.mps,
    this._viewMPBloc,
    /* this._editMPBloc*/
  ) {
    _rows = mps
        .map((data) => _Row(data.date, data.sname, data.billno, data.mname,
            data.unitprice, data.quantity, data.price, data.remarks, data))
        .toList();
  }

  final BuildContext context;
  List<_Row> _rows;
  List<MaterialPurchase> mps;
  ViewMPBloc _viewMPBloc;
  MPBloc _editMPBloc; /**/

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      // selected: row.selected,
      // onSelectChanged: (value) {
      //   if (row.selected != value) {
      //     _selectedCount += value ? 1 : -1;
      //     assert(_selectedCount >= 0);
      //     row.selected = value;
      //     notifyListeners();
      //   }
      // },
      cells: [
        DataCell(Text(row.valueA)),
        DataCell(Text(row.valueB)),
        DataCell(Text(row.valueC)),
        DataCell(Text(row.valueD)),
        DataCell(Text(row.valueE)),
        DataCell(Text(row.valueF)),
        DataCell(Text(row.valueG)),
        DataCell(Text(row.valueH)),
        // DataCell(Text("row.valueH")),
        _modifyDataCell(row.mp),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  DataCell _modifyDataCell(data) {
    return DataCell(
      Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.edit,
              // color: kPrimaryAccentColor,
            ),
            onPressed: () {
              // _showModalBottomSheet(context, data);
              Navigator.pushNamed(context, kEditMPScreen, arguments: data);
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
                      'Are you sure you want to delete "${data.mname}"?',
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            // _editMPBloc.add(DeleteMP(mcode: data.mcode));
                            // Navigator.pop(context);
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

  // Future<void> _showModalBottomSheet(BuildContext context, material.MP data) {
  //   return showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SingleChildScrollView(
  //         child: Container(
  //           padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom),
  //           child: BlocProvider(
  //             create: (BuildContext context) => MPBloc(),
  //             child: MPBottomSheet(
  //               viewMPBloc: _viewMPBloc,
  //               materialName: data.mname,
  //               materialcode: data.mcode,
  //               materialUnit: data.munit,
  //               materialPrice: data.mpriceperunit,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //     isScrollControlled: true,
  //   );
  // }
}
