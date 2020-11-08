import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/delete_card.dart';
import 'package:hb_mobile/widgets/profile_card.dart';
import 'package:hb_mobile/widgets/search_widget.dart';

class ExistingEmployeesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              ViewEmployeeBloc()..add(FetchEmployeeEvent()),
        ),
        BlocProvider(
          create: (BuildContext context) => EmployeeBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Existing Employees'),
          actions: [
            EmployeeAppBarAction(),
          ],
        ),
        body: ExistingEmployeesList(),
      ),
    );
  }
}

class EmployeeAppBarAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.refresh),
      onPressed: () =>
          BlocProvider.of<ViewEmployeeBloc>(context).add(FetchEmployeeEvent()),
    );
  }
}

class ExistingEmployeesList extends StatefulWidget {
  @override
  _ExistingEmployeesListState createState() => _ExistingEmployeesListState();
}

class _ExistingEmployeesListState extends State<ExistingEmployeesList> {
  ViewEmployeeBloc _viewEmployeeBloc;
  EmployeeBloc _editEmployeeBloc;

  @override
  void initState() {
    _viewEmployeeBloc = BlocProvider.of<ViewEmployeeBloc>(context);
    _editEmployeeBloc = BlocProvider.of<EmployeeBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _viewEmployeeBloc.close();
    _editEmployeeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeBloc, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeSuccess) {
          _viewEmployeeBloc.add(FetchEmployeeEvent());
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
      child: BlocBuilder<ViewEmployeeBloc, ViewEmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoadingState) {
            return LinearProgressIndicator();
          }
          if (state is EmployeeLoadedState) {
            final employees = state.employees;

            return _buildCards(state, employees);
          }
          if (state is EmployeeErrorState) {
            return _errorMessage(state, context);
          } else {
            return Text('unknown state error please report to developer');
          }
        },
      ),
    );
  }

  Widget _buildCards(EmployeeLoadedState state, List<Employee> employees) {
    return Column(
      children: [
        SizedBox(height: 8.0),
        SearchWidget(
          child: TextField(
            style: TextStyle(color: Colors.white),
            onChanged: (query) => _viewEmployeeBloc
                .add(SearchAndFetchEmployeeEvent(ename: query)),
            decoration: kSearchTextFieldDecoration,
          ),
        ),
        SizedBox(height: 8.0),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1));
              _viewEmployeeBloc.add(FetchEmployeeEvent());
            },
            child: _buildCardList(state, employees),
          ),
        ),
      ],
    );
  }

  Widget _buildCardList(EmployeeLoadedState state, List<Employee> employees) {
    if (employees.length == 0) {
      return Center(child: Text("no results found"));
    }
    return ListView.builder(
      itemCount: state.employees.length,
      itemBuilder: (context, index) {
        return _buildCard(employees, index, context);
      },
    );
  }

  Widget _buildCard(List<Employee> employees, int index, BuildContext context) {
    return ProfileCard(
      cardKey: "${employees[index].ecode}",
      title: "${employees[index].ename}",
      subtitle: "${employees[index].enumber}",
      date: "${employees[index].eaddate}",
      id: "${employees[index].ecode}",
      detail: "${employees[index].eaddress}",
      editCard: _editCard(context, employees, index),
      deleteCard: _deleteCard(context, employees, index),
    );
    // return ExpansionTile(
    //   title: Text('${employees[index].ename}'),
    //   subtitle: Text('${employees[index].enumber}'),
    //   trailing: Text('${employees[index].eaddate}'),
    //   children: [
    //     Row(
    //       children: [
    //         Padding(
    //           padding: kHorizontalPadding,
    //           child: Text('${employees[index].eaddress}'),
    //         ),
    //       ],
    //     ),
    //     Row(
    //       children: [
    //         Padding(
    //           padding: kHorizontalPadding,
    //           child: Text('${employees[index].ecode}'),
    //         ),
    //         IconButton(
    //           onPressed: () {
    //             _showModalBottomSheet(context, employees, index);
    //           },
    //           icon: Icon(Icons.edit),
    //         ),
    //         IconButton(
    //           onPressed: () {
    //             showDialog(
    //               context: context,
    //               builder: (_) => AlertDialog(
    //                 title: Text(
    //                   'Are you sure you want to delete "${employees[index].ename}"?',
    //                 ),
    //                 actions: [
    //                   FlatButton(
    //                       onPressed: () {
    //                         _editEmployeeBloc.add(
    //                             DeleteEmployee(ecode: employees[index].ecode));
    //                         Navigator.pop(context);
    //                       },
    //                       child: Text('Yes')),
    //                   FlatButton(
    //                       onPressed: () => Navigator.pop(context),
    //                       child: Text('No')),
    //                 ],
    //               ),
    //             );
    //           },
    //           icon: Icon(Icons.delete),
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }

  Widget _deleteCard(
      BuildContext context, List<Employee> employees, int index) {
    return DeleteCard(
      title: 'Are you sure you want to delete "${employees[index].ename}"?',
      actions: [
        FlatButton(
            onPressed: () {
              _editEmployeeBloc
                  .add(DeleteEmployee(ecode: employees[index].ecode));
              Navigator.pop(context);
            },
            child: Text('Yes')),
        FlatButton(onPressed: () => Navigator.pop(context), child: Text('No')),
      ],
    );
  }

  IconButton _editCard(
      BuildContext context, List<Employee> employees, int index) {
    return IconButton(
      onPressed: () {
        _showModalBottomSheet(context, employees, index);
      },
      icon: Icon(Icons.edit),
    );
  }

  Future<void> _showModalBottomSheet(
      BuildContext context, List<Employee> employees, int index) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: BlocProvider(
              create: (BuildContext context) => EmployeeBloc(),
              child: EmployeeBottomSheet(
                viewEmployeeBloc: _viewEmployeeBloc,
                employeecode: employees[index].ecode,
                employeeContact: employees[index].enumber,
                employeeName: employees[index].ename,
                employeeAddress: employees[index].eaddress,
              ),
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  Widget _errorMessage(EmployeeErrorState state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${state.message}'),
          RaisedButton(
              onPressed: () {
                BlocProvider.of<ViewEmployeeBloc>(context)
                    .add(FetchEmployeeEvent());
              },
              child: Text('refresh')),
        ],
      ),
    );
  }
}
