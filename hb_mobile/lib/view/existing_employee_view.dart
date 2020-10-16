import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (query) => _viewEmployeeBloc
                .add(SearchAndFetchEmployeeEvent(ename: query)),
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Search employees'),
          ),
        ),
        Expanded(
          child: _buildCardList(state, employees),
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
    return ExpansionTile(
      title: Text('${employees[index].ename}'),
      subtitle: Text('${employees[index].enumber}'),
      trailing: Text('${employees[index].eaddate}'),
      children: [
        Row(
          children: [
            Padding(
              padding: kHorizontalPadding,
              child: Text('${employees[index].eaddress}'),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: kHorizontalPadding,
              child: Text('${employees[index].ecode}'),
            ),
            IconButton(
              onPressed: () {
                _showModalBottomSheet(context, employees, index);
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(
                      'Are you sure you want to delete "${employees[index].ename}"?',
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            _editEmployeeBloc.add(
                                DeleteEmployee(ecode: employees[index].ecode));
                            Navigator.pop(context);
                          },
                          child: Text('Yes')),
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('No')),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ],
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

class EmployeeBottomSheet extends StatefulWidget {
  final viewEmployeeBloc;
  final String employeecode;
  final String employeeName;
  final String employeeContact;
  final String employeeAddress;

  const EmployeeBottomSheet({
    Key key,
    @required this.employeecode,
    @required this.employeeName,
    @required this.employeeContact,
    @required this.employeeAddress,
    this.viewEmployeeBloc,
  }) : super(key: key);

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<EmployeeBottomSheet> {
  EmployeeBloc _addEmployeeBloc;
  TextEditingController _employeeNameController;
  TextEditingController _employeeCodeController;
  TextEditingController _contactController;
  TextEditingController _addressController;
  TextEditingController _addDateController;

  @override
  void initState() {
    _addEmployeeBloc = BlocProvider.of<EmployeeBloc>(context);
    _employeeNameController = TextEditingController();
    _employeeCodeController = TextEditingController();
    _contactController = TextEditingController();
    _addressController = TextEditingController();
    _addDateController = TextEditingController();
    setValues();
    super.initState();
  }

  void setValues() {
    _employeeCodeController.text = widget.employeecode;
    _employeeNameController.text = widget.employeeName;
    _contactController.text = widget.employeeContact;
    _addressController.text = widget.employeeAddress;
    _addDateController.text = _addEmployeeBloc.getDateInFormat;
  }

  @override
  void dispose() {
    _employeeNameController.dispose();
    _employeeCodeController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _addDateController.dispose();
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
          BlocListener<EmployeeBloc, EmployeeState>(
            listener: (context, state) {
              if (state is EmployeeSuccess) {
                widget.viewEmployeeBloc.add(FetchEmployeeEvent());
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeError) {
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
                    child: Text('Edit Employee'),
                  );
                }
              },
            ),
          ),
          InputField(
            child: TextField(
              enabled: false,
              controller: _employeeCodeController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Employee code',
              ),
            ),
            iconData: Icons.info,
            isDisabled: true,
          ),
          InputField(
            child: TextField(
              enabled: false,
              controller: _addDateController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Date',
              ),
            ),
            iconData: Icons.calendar_today,
            isDisabled: true,
          ),
          InputField(
            child: TextField(
              controller: _employeeNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Name',
              ),
            ),
            iconData: Icons.person,
          ),
          InputField(
            child: TextField(
              controller: _contactController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Contact',
              ),
            ),
            iconData: Icons.call,
          ),
          InputField(
            child: TextField(
              minLines: 1,
              maxLines: 2,
              controller: _addressController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Address',
              ),
            ),
            iconData: Icons.home,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PrimaryActionButton(
                  title: 'Change',
                  onPressed: () {
                    uploadData();
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

  void uploadData() {
    _addEmployeeBloc
      ..add(
        EditEmployee(
          ename: _employeeNameController.text,
          eaddate: _addDateController.text,
          eaddress: _addressController.text,
          ecode: _employeeCodeController.text,
          enumber: _contactController.text,
        ),
      );
  }
}
