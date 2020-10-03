import 'package:core/core.dart';
import 'package:core/src/business_logics/bloc/material_bloc.dart'
    as materialBloc;
import 'package:core/src/business_logics/models/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

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
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            autofocus: false,
            onChanged: (query) => _viewMaterialBloc
                .add(SearchAndFetchMaterialEvent(mname: query)),
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Search materials'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text('total results: ${materials.length}'),
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
          columnSpacing: 1.0,
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
              child: BottomSheet(
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

class BottomSheet extends StatefulWidget {
  final viewMaterialBloc;
  final String materialcode;
  final String materialName;
  final String materialUnit;
  final String materialPrice;

  const BottomSheet({
    Key key,
    @required this.materialcode,
    @required this.materialName,
    @required this.materialUnit,
    @required this.materialPrice,
    this.viewMaterialBloc,
  }) : super(key: key);

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  MaterialBloc _addMaterialBloc;
  TextEditingController _materialNameController;
  TextEditingController _materialCodeController;
  TextEditingController _materialUnitController;
  TextEditingController _materialPriceController;

  @override
  void initState() {
    _addMaterialBloc = BlocProvider.of<MaterialBloc>(context);
    _materialNameController = TextEditingController();
    _materialCodeController = TextEditingController();
    _materialUnitController = TextEditingController();
    _materialPriceController = TextEditingController();
    setValues();
    super.initState();
  }

  void setValues() {
    _materialNameController.text = widget.materialName;
    _materialCodeController.text = widget.materialcode;
    _materialUnitController.text = widget.materialUnit;
    _materialPriceController.text = widget.materialPrice;
  }

  @override
  void dispose() {
    _materialNameController.dispose();
    _materialCodeController.dispose();
    _materialUnitController.dispose();
    _materialPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPrimaryPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BlocListener<MaterialBloc, materialBloc.MaterialState>(
            listener: (context, state) {
              if (state is MaterialSuccess) {
                widget.viewMaterialBloc.add(FetchMaterialEvent());
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<MaterialBloc, materialBloc.MaterialState>(
              builder: (context, state) {
                if (state is MaterialError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${state.message}',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Edit Material'),
                  );
                }
              },
            ),
          ),
          InputField(
            textField: TextField(
              controller: _materialNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Material Name',
              ),
            ),
            iconData: Icons.bookmark,
          ),
          InputField(
            textField: TextField(
              enabled: false,
              controller: _materialCodeController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Material code',
              ),
            ),
            iconData: Icons.info,
            isDisabled: true,
          ),
          InputField(
            textField: TextField(
              controller: _materialUnitController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Unit',
              ),
            ),
            iconData: Icons.chevron_right,
          ),
          InputField(
            textField: TextField(
              controller: _materialPriceController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Price per unit',
              ),
            ),
            iconData: Icons.attach_money,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PrimaryActionButton(
                  title: 'Change',
                  onPressed: () {
                    _uploadData();
                  },
                ),
                RaisedButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _uploadData() {
    _addMaterialBloc
      ..add(
        EditMaterial(
          mname: _materialNameController.text,
          mpriceperunit: _materialPriceController.text,
          mcode: _materialCodeController.text,
          munit: _materialUnitController.text,
        ),
      );
  }
}
