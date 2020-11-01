import 'package:core/core.dart';
import 'package:core/src/business_logics/bloc/material_bloc.dart'
    as materialBloc;
import 'package:core/src/business_logics/models/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/material_data_table_widget.dart';
import 'package:hb_mobile/widgets/navigate_back_widget.dart';
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
        leading: NavigateBackButton(),
        actions: [
          AppbarDropDownMenu(),
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
              style: TextStyle(color: Colors.white),
              autofocus: false,
              onChanged: (query) => _viewMaterialBloc
                  .add(SearchAndFetchMaterialEvent(mname: query)),
              decoration: kSearchTextFieldDecoration,
            ),
          ),
        ),
        Expanded(
          child: _buildPaginatedDataTable(state, materials),
        ),
      ],
    );
  }

  Widget _buildPaginatedDataTable(
      MaterialLoadedState state, List<material.Material> materials) {
    return MaterialDataTable(
      dataColumn: [
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
      materials: materials,
      viewMaterialBloc: _viewMaterialBloc,
      editMaterialBloc: _editMaterialBloc,
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

class AppbarDropDownMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (choice) {
        choiceAction(choice, context);
      },
      itemBuilder: (BuildContext context) {
        return MaterialConstants.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  void choiceAction(String choice, BuildContext context) {
    if (choice == MaterialConstants.Settings) {
      print('Settings');
    } else if (choice == MaterialConstants.Refresh) {
      BlocProvider.of<ViewMaterialBloc>(context).add(FetchMaterialEvent());
    } else if (choice == MaterialConstants.AddMaterial) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          kAddMaterialScreen, ModalRoute.withName(kConfigScreen));
    }
  }
}
