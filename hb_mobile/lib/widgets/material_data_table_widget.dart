import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:core/src/business_logics/models/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/material_bottom_sheet_widget.dart';

class MaterialDataTable extends StatelessWidget {
  final List<DataColumn> dataColumn;
  final List<material.Material> materials;
  final ViewMaterialBloc viewMaterialBloc;
  final MaterialBloc editMaterialBloc;

  const MaterialDataTable(
      {Key key,
      this.dataColumn,
      this.materials,
      this.viewMaterialBloc,
      this.editMaterialBloc})
      : super(key: key);

  Widget build(BuildContext context) {
    final bool isEmpty = materials.length < 1;

    return Padding(
      padding: kPrimaryPadding,
      child: ListView(
        children: [
          PaginatedDataTable(
            columnSpacing: 10,
            header: Text(isEmpty ? 'No result found' : 'Material'),
            rowsPerPage: isEmpty ? 1 : 6,
            columns: dataColumn,
            source: _DataSource(
                context, materials, viewMaterialBloc, editMaterialBloc),
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
  );

  final String valueA;
  final String valueB;
  final String valueC;
  final String valueD;
  final material.Material valueE;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this.materials, this._viewMaterialBloc,
      this._editMaterialBloc) {
    _rows = materials
        .map((data) =>
            _Row(data.mname, data.mcode, data.munit, data.mpriceperunit, data))
        .toList();
  }

  final BuildContext context;
  List<_Row> _rows;
  List<material.Material> materials;
  ViewMaterialBloc _viewMaterialBloc;
  MaterialBloc _editMaterialBloc;

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
        DataCell(Text(row.valueD.toString())),
        _modifyDataCell(row.valueE),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  DataCell _modifyDataCell(material.Material data) {
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
                      'Are you sure you want to delete "${data.mname}"?',
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            _editMaterialBloc
                                .add(DeleteMaterial(mcode: data.mcode));
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

  Future<void> _showModalBottomSheet(
      BuildContext context, material.Material data) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: BlocProvider(
              create: (BuildContext context) => MaterialBloc(),
              child: MaterialBottomSheet(
                viewMaterialBloc: _viewMaterialBloc,
                materialName: data.mname,
                materialcode: data.mcode,
                materialUnit: data.munit,
                materialPrice: data.mpriceperunit,
              ),
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }
}
