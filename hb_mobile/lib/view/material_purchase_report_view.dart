// import 'package:core/core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hb_mobile/constant.dart';
//
// class MaterialPurchase extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => MaterialPurchaseReportBloc()..add(MaterialDetails()),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Material Purchase'),
//         ),
//         body: BlocBuilder<MaterialPurchaseReportBloc,
//             MaterialPurchaseReportState>(
//           builder: (context, state) {
//             return Text('${state.materialPurchase.code}');
//           },
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           onPressed: () {
//             Navigator.pushNamed(context, kMaterialPurchaseEntry);
//           },
//           label: Text('Entry'),
//           icon: Icon(Icons.add),
//           backgroundColor: Colors.pink,
//         ),
//       ),
//     );
//   }
// }
//
// /*
// body: Container(
//         child: SingleChildScrollView(
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columns: [
//                 DataColumn(label: Text('Date')),
//                 DataColumn(label: Text('Supplier')),
//                 DataColumn(label: Text('Bill No')),
// //                DataColumn(label: Text('Material')),
// //                DataColumn(label: Text('Unit')),
// //                DataColumn(label: Text('Quantity')),
// //                DataColumn(label: Text('Total')),
// //                DataColumn(label: Text('Remarks')),
//               ],
//               rows: [
//                 DataRow(cells: [
//                   DataCell(Text('data')),
//                   DataCell(Text('data')),
//                   DataCell(Text('data')),
//                 ]),
//                 DataRow(cells: [
//                   DataCell(Text('data')),
//                   DataCell(Text('data')),
//                   DataCell(Text('data')),
//                 ]),
//                 DataRow(cells: [
//                   DataCell(Text('data')),
//                   DataCell(Text('data')),
//                   DataCell(Text('data')),
//                 ]),
//               ],
//             ),
//           ),
//         ),
//       ),
//
// */
