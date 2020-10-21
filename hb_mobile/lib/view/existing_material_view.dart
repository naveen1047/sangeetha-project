import 'package:core/core.dart';
import 'package:core/src/business_logics/bloc/material_bloc.dart'
    as materialBloc;
import 'package:core/src/business_logics/models/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/material_bottom_sheet_widget.dart';
import 'package:hb_mobile/widgets/search_widget.dart';

class ExistingMaterialsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              ViewMaterialBloc()..add(FetchMaterialEvent()),
        ),
        BlocProvider(
          create: (BuildContext context) => MaterialBloc(),
        ),
      ],
      child: ExistingMaterialsList(),
    );
  }
}

class ExistingMaterialsList extends StatefulWidget {
  @override
  _ExistingMaterialsListState createState() => _ExistingMaterialsListState();
}

class _ExistingMaterialsListState extends State<ExistingMaterialsList> {
  ViewMaterialBloc _viewMaterialBloc;
  MaterialBloc _editMaterialBloc;

  @override
  void initState() {
    _viewMaterialBloc = BlocProvider.of<ViewMaterialBloc>(context);
    _editMaterialBloc = BlocProvider.of<MaterialBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _viewMaterialBloc.close();
    _editMaterialBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Materials'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _viewMaterialBloc.add(FetchMaterialEvent()),
          )
        ],
      ),
      body: BlocListener<MaterialBloc, materialBloc.MaterialState>(
        listener: (context, state) {
          if (state is MaterialSuccess) {
            _viewMaterialBloc.add(FetchMaterialEvent());
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
        child: BlocBuilder<ViewMaterialBloc, ViewMaterialState>(
          builder: (context, state) {
            if (state is MaterialLoadingState) {
              return LinearProgressIndicator();
            }
            if (state is MaterialLoadedState) {
              final List<material.Material> materials = state.materials;

              return _buildTable(state, materials);
            }
            if (state is MaterialErrorState) {
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
      MaterialLoadedState state, List<material.Material> materials) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: kTopPadding,
          child: SearchWidget(
            child: TextField(
              autofocus: false,
              onChanged: (query) => _viewMaterialBloc
                  .add(SearchAndFetchMaterialEvent(mname: query)),
              decoration: kSearchTextFieldDecoration,
            ),
          ),
        ),
        Padding(
          padding: kFieldPadding,
          child: Text(
            'Total results: ${materials.length}',
            style: kDatatableLabelStyle,
          ),
        ),
        Expanded(
          child: _buildDataTable(state, materials),
        ),
      ],
    );
  }

  Widget _buildDataTable(
      MaterialLoadedState state, List<material.Material> materials) {
    if (materials.length == 0) {
      return Center(child: Text("no results found"));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 0.5,
          dividerThickness: 0.5,
          columns: [
            DataColumn(
                label: datatableLabel("Material", isSortable: true),
                onSort: (columnIndex, ascending) {
                  _viewMaterialBloc.add(SortMaterialByName());
                }),
            DataColumn(
                label: datatableLabel("Unit", isSortable: true),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  _viewMaterialBloc.add(SortMaterialByUnit());
                }),
            DataColumn(
                label: datatableLabel("Price per unit", isSortable: true),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  _viewMaterialBloc.add(SortMaterialByPrice());
                }),
            DataColumn(
              label: datatableLabel("Code"),
            ),
            DataColumn(
                label: datatableLabel(
              "Modify / delete",
            )),
          ],
          rows: materials
              .map(
                (data) => DataRow(
                  cells: [
                    DataCell(Text(data.mname)),
                    DataCell(Text(data.munit)),
                    DataCell(Text(data.mpriceperunit)),
                    DataCell(Text(data.mcode), placeholder: true),
                    _modifyDataCell(data),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  DataCell _modifyDataCell(material.Material data) {
    return DataCell(
      Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showModalBottomSheet(context, data);
            },
          ),
          IconButton(
              icon: Icon(Icons.delete),
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

  Widget _errorMessage(MaterialErrorState state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${state.message}'),
          RaisedButton(
              onPressed: () {
                BlocProvider.of<ViewMaterialBloc>(context)
                    .add(FetchMaterialEvent());
              },
              child: Text('refresh')),
        ],
      ),
    );
  }
}
