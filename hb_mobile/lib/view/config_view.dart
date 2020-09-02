
import 'package:flutter/material.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class ConfigScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Config'),
      ),
      body: ListView(
        children: [
          DualButton(
            title: 'Add Suppliers',
            subtitle: 'Existing suppliers',
            primaryColor: Colors.grey,
            onTapSecondary: () {
              Navigator.pushNamed(context, kExistingSuppliersScreen);
            },
            onTapPrimary: () {
              Navigator.pushNamed(context, kAddSuppliers);
            },
          ),
          DualButton(
            title: 'Add Material',
            subtitle: 'Existing material',
            primaryColor: Colors.amber,
            onTapSecondary: () {},
            onTapPrimary: () {},
          ),
          DualButton(
            title: 'Change price',
            subtitle: 'Already prices material',
            primaryColor: Colors.brown,
            onTapSecondary: () {},
            onTapPrimary: () {},
          ),
          DualButton(
            title: 'Add Employee',
            subtitle: 'Existing Employee',
            primaryColor: Colors.blue,
            onTapSecondary: () {},
            onTapPrimary: () {},
          ),
          DualButton(
            title: 'Add Product',
            subtitle: 'Existing products',
            primaryColor: Colors.teal,
            onTapSecondary: () {},
            onTapPrimary: () {},
          ),
        ],
      ),
    );
  }
}
