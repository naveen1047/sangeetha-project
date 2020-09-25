import 'package:core/core.dart';
import 'package:core/src/business_logics/bloc/material_bloc.dart'
    as materialBloc;
import 'package:core/src/business_logics/models/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            onPressed: () => BlocProvider.of<ViewMaterialBloc>(context)
                .add(FetchMaterialEvent()),
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
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (query) => _viewMaterialBloc
                .add(SearchAndFetchMaterialEvent(mname: query)),
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Search materials'),
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
          columns: [
            DataColumn(
                label: Text("Material"),
                onSort: (columnIndex, ascending) {
                  setState(() {});
                }),
            DataColumn(label: Text("Code")),
            DataColumn(label: Text("Unit")),
            DataColumn(label: Text("Price per unit")),
          ],
          rows: materials
              .map(
                (data) => DataRow(
                  cells: [
                    DataCell(Text(data.mname)),
                    DataCell(Text(data.mcode)),
                    DataCell(Text(data.munit)),
                    DataCell(Text(data.mpriceperunit)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // Widget _buildCard(
  //     List<material.Material> materials, int index, BuildContext context) {
  //   return ExpansionTile(
  //     title: Text('${materials[index].sname}'),
  //     subtitle: Text('${materials[index].snum}'),
  //     trailing: Text('${materials[index].saddate}'),
  //     children: [
  //       Row(
  //         children: [
  //           Padding(
  //             padding: kHorizontalPadding,
  //             child: Text('${materials[index].saddress}'),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         children: [
  //           Padding(
  //             padding: kHorizontalPadding,
  //             child: Text('${materials[index].scode}'),
  //           ),
  //           IconButton(
  //             onPressed: () {
  //               _showModalBottomSheet(context, materials, index);
  //             },
  //             icon: Icon(Icons.edit),
  //           ),
  //           IconButton(
  //             onPressed: () {
  //               showDialog(
  //                 context: context,
  //                 builder: (_) => AlertDialog(
  //                   title: Text(
  //                     'Are you sure you want to delete "${materials[index].sname}"?',
  //                   ),
  //                   actions: [
  //                     FlatButton(
  //                         onPressed: () {
  //                           _editMaterialBloc.add(
  //                               DeleteMaterial(scode: materials[index].scode));
  //                           Navigator.pop(context);
  //                         },
  //                         child: Text('Yes')),
  //                     FlatButton(
  //                         onPressed: () => Navigator.pop(context),
  //                         child: Text('No')),
  //                   ],
  //                 ),
  //               );
  //             },
  //             icon: Icon(Icons.delete),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
  //
  // Future<void> _showModalBottomSheet(
  //     BuildContext context, List<material.Material> materials, int index) {
  //   return showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SingleChildScrollView(
  //         child: Container(
  //           padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom),
  //           child: BlocProvider(
  //             create: (BuildContext context) => MaterialBloc(),
  //             child: BottomSheet(
  //               viewMaterialBloc: _viewMaterialBloc,
  //               materialcode: materials[index].scode,
  //               materialContact: materials[index].snum,
  //               materialName: materials[index].sname,
  //               materialAddress: materials[index].saddress,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //     isScrollControlled: true,
  //   );
  // }

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
//
// class BottomSheet extends StatefulWidget {
//   final viewMaterialBloc;
//   final String materialcode;
//   final String materialName;
//   final String materialContact;
//   final String materialAddress;
//
//   const BottomSheet({
//     Key key,
//     @required this.materialcode,
//     @required this.materialName,
//     @required this.materialContact,
//     @required this.materialAddress,
//     this.viewMaterialBloc,
//   }) : super(key: key);
//
//   @override
//   _BottomSheetState createState() => _BottomSheetState();
// }
//
// class _BottomSheetState extends State<BottomSheet> {
//   MaterialBloc _addMaterialBloc;
//   TextEditingController _materialNameController;
//   TextEditingController _materialCodeController;
//   TextEditingController _contactController;
//   TextEditingController _addressController;
//   TextEditingController _addDateController;
//
//   @override
//   void initState() {
//     _addMaterialBloc = BlocProvider.of<MaterialBloc>(context);
//     _materialNameController = TextEditingController();
//     _materialCodeController = TextEditingController();
//     _contactController = TextEditingController();
//     _addressController = TextEditingController();
//     _addDateController = TextEditingController();
//     setValues();
//     super.initState();
//   }
//
//   void setValues() {
//     _materialCodeController.text = widget.materialcode;
//     _materialNameController.text = widget.materialName;
//     _contactController.text = widget.materialContact;
//     _addressController.text = widget.materialAddress;
//     _addDateController.text = _addMaterialBloc.getDateInFormat;
//   }
//
//   @override
//   void dispose() {
//     _materialNameController.dispose();
//     _materialCodeController.dispose();
//     _contactController.dispose();
//     _addressController.dispose();
//     _addDateController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: kPrimaryPadding,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           BlocListener<MaterialBloc, MaterialState>(
//             listener: (context, state) {
//               if (state is MaterialSuccess) {
//                 widget.viewMaterialBloc.add(FetchMaterialEvent());
//                 Navigator.pop(context);
//               }
//             },
//             child: BlocBuilder<MaterialBloc, MaterialState>(
//               builder: (context, state) {
//                 if (state is MaterialError) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       '${state.message}',
//                       style: TextStyle(
//                         color: Colors.red,
//                       ),
//                     ),
//                   );
//                 } else {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text('Edit Material'),
//                   );
//                 }
//               },
//             ),
//           ),
//           InputField(
//             textField: TextField(
//               enabled: false,
//               controller: _materialCodeController,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: 'Material code',
//               ),
//             ),
//             iconData: Icons.info,
//             isDisabled: true,
//           ),
//           InputField(
//             textField: TextField(
//               enabled: false,
//               controller: _addDateController,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: 'Date',
//               ),
//             ),
//             iconData: Icons.calendar_today,
//             isDisabled: true,
//           ),
//           InputField(
//             textField: TextField(
//               controller: _materialNameController,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: 'Name',
//               ),
//             ),
//             iconData: Icons.person,
//           ),
//           InputField(
//             textField: TextField(
//               controller: _contactController,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: 'Contact',
//               ),
//             ),
//             iconData: Icons.call,
//           ),
//           InputField(
//             textField: TextField(
//               minLines: 1,
//               maxLines: 2,
//               controller: _addressController,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: 'Address',
//               ),
//             ),
//             iconData: Icons.home,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 PrimaryActionButton(
//                   title: 'Change',
//                   onPressed: () {
//                     uploadData();
//                   },
//                 ),
//                 RaisedButton(
//                   child: const Text('Cancel'),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   void uploadData() {
//     _addMaterialBloc
//       ..add(
//         EditMaterial(
//           sname: _materialNameController.text,
//           saddate: _addDateController.text,
//           saddress: _addressController.text,
//           scode: _materialCodeController.text,
//           snum: _contactController.text,
//         ),
//       );
//   }
// }
