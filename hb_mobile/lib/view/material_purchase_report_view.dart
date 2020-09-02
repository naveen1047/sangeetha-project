import 'package:flutter/material.dart';
import 'package:hb_mobile/constant.dart';

class MaterialPurchase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Purchase'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Supplier')),
                DataColumn(label: Text('Bill No')),
//                DataColumn(label: Text('Material')),
//                DataColumn(label: Text('Unit')),
//                DataColumn(label: Text('Quantity')),
//                DataColumn(label: Text('Total')),
//                DataColumn(label: Text('Remarks')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('data')),
                  DataCell(Text('data')),
                  DataCell(Text('data')),
                ]),
                DataRow(cells: [
                  DataCell(Text('data')),
                  DataCell(Text('data')),
                  DataCell(Text('data')),
                ]),
                DataRow(cells: [
                  DataCell(Text('data')),
                  DataCell(Text('data')),
                  DataCell(Text('data')),
                ]),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, kMaterialPurchaseEntry);
        },
        label: Text('Entry'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
