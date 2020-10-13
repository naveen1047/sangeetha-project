import 'package:flutter/material.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class ConfigScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final configWidgets = [
      DualButton(
        title: 'Add Suppliers',
        subtitle: 'Existing suppliers',
        primaryColor: Colors.grey,
        onTapSecondary: () =>
            Navigator.pushNamed(context, kExistingSuppliersScreen),
        onTapPrimary: () => Navigator.pushNamed(context, kAddSuppliersScreen),
      ),
      DualButton(
        title: 'Add Material',
        subtitle: 'Existing material',
        primaryColor: Colors.amber,
        onTapSecondary: () =>
            Navigator.pushNamed(context, kExistingMaterialScreen),
        onTapPrimary: () => Navigator.pushNamed(context, kAddMaterialScreen),
      ),
      // DualButton(
      //   title: 'Change price',
      //   subtitle: 'Already prices material',
      //   primaryColor: Colors.brown,
      //   onTapSecondary: () {},
      //   onTapPrimary: () {},
      // ),
      DualButton(
        title: 'Add Employee',
        subtitle: 'Existing Employee',
        primaryColor: Colors.blue,
        onTapSecondary: () =>
            Navigator.pushNamed(context, kExistingEmployeeScreen),
        onTapPrimary: () => Navigator.pushNamed(context, kAddEmployeeScreen),
      ),
      DualButton(
        title: 'Add Product',
        subtitle: 'Existing products',
        primaryColor: Colors.teal,
        onTapSecondary: () {},
        onTapPrimary: () {},
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Config'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxHeight > constraints.maxWidth) {
            return ListView(
              children: configWidgets,
            );
          } else {
            return GridView.count(
              crossAxisCount: 3,
              children: configWidgets,
            );
          }
        },
      ),
    );
  }
}

class BuildConfigLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxHeight > constraints.maxWidth) {
          return Text('asdf');
        } else {
          return Text('fgasrf');
        }
      },
    );
  }
}
