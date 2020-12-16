import 'package:core/core.dart';
import 'package:core/src/business_logics/bloc/view_mp_bloc/view_mp_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/mp_data_table.dart';
// import 'package:hb_mobile/widgets/material_data_table_widget.dart';
import 'package:hb_mobile/widgets/navigate_back_widget.dart';
import 'package:hb_mobile/widgets/search_widget.dart';

class ExistingMPScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ViewMPBloc()..add(FetchMPEvent()),
        ),
        // BlocProvider(
        //   create: (BuildContext context) => MaterialBloc(),
        // ),
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
  ViewMPBloc _viewMPBloc;
  // MaterialBloc _editMaterialBloc;

  @override
  void initState() {
    _viewMPBloc = BlocProvider.of<ViewMPBloc>(context);
    // _editMaterialBloc = BlocProvider.of<MaterialBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _viewMPBloc.close();
    // _editMaterialBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Purchase'),
        leading: NavigateBackButton(),
        actions: [
          AppbarDropDownMenu(),
        ],
      ),
      body: BlocBuilder<ViewMPBloc, ViewMPState>(
        builder: (context, state) {
          if (state is ViewMPLoadingState) {
            return LinearProgressIndicator();
          }
          if (state is ViewMPLoadedState) {
            final List<MaterialPurchase> mps = state.materialPurchase;
            print(" ............${mps.length}");
            return _buildTable(state, mps);
          }
          if (state is ViewMPErrorState) {
            return _errorMessage(state, context);
          } else {
            return Text('unknown state error please report to developer');
          }
        },
      ),
    );
  }

  Widget _buildTable(ViewMPLoadedState state, List<MaterialPurchase> mp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: kTopPadding,
          child: SearchWidget(
            child: TextField(
              style: TextStyle(color: Colors.white),
              autofocus: false,
              onChanged: (query) =>
                  _viewMPBloc.add(SearchAndFetchMPEvent(billNo: query)),
              decoration: kSearchTextFieldDecoration,
            ),
          ),
        ),
        Expanded(
          child: _buildPaginatedDataTable(state, mp),
        ),
      ],
    );
  }

  Widget _buildPaginatedDataTable(
      ViewMPLoadedState state, List<MaterialPurchase> mp) {
    return MPDataTable(
      dataColumn: [
        DataColumn(
          label: datatableLabel("Date", isSortable: true),
        ),
        DataColumn(
          label: datatableLabel("Supplier", isSortable: true),
          // onSort: (columnIndex, ascending) {
          //   _viewMPBloc.add(SortMaterialByName());
          // },
        ),
        DataColumn(
          label: datatableLabel("Bill no", isSortable: true),
        ),
        DataColumn(
          label: datatableLabel("Material", isSortable: true),
        ),
        DataColumn(
          label: datatableLabel("Unit", isSortable: true),
        ),
        DataColumn(
          label: datatableLabel("Quantity", isSortable: true),
        ),
        DataColumn(
          label: datatableLabel("Total", isSortable: true),
        ),
        DataColumn(
          label: datatableLabel("Remarks", isSortable: true),
        ),
        DataColumn(
          label: datatableLabel("Modify/Delete"),
        ),
      ],
      // materials: materials,
      viewMPBloc: _viewMPBloc,
      mps: mp,
      // editMaterialBloc: _editMaterialBloc,
    );
  }

  Widget _errorMessage(ViewMPErrorState state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${state.message}'),
          RaisedButton(
              onPressed: () {
                BlocProvider.of<ViewMPBloc>(context).add(FetchMPEvent());
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
    if (choice == MPConstants.Settings) {
      print('Settings');
    } else if (choice == MPConstants.Refresh) {
      BlocProvider.of<ViewMPBloc>(context).add(FetchMPEvent());
    } else if (choice == MPConstants.AddMP) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          kAddMaterialScreen, ModalRoute.withName(kConfigScreen));
    }
  }
}
