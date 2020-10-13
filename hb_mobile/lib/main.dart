import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/simple_bloc_observer.dart';
import 'package:hb_mobile/view/existing_material_view.dart';
import 'package:hb_mobile/view/view.dart';

import 'constant.dart';

/*
*   Task:
*   MaterialPurchase
* */
void main() {
  setupServiceLocator();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(
    title: 'Sangeetha groups',
  ));
}

class MyApp extends StatelessWidget {
  final String title;

  const MyApp({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: kHome,
      routes: {
        kHome: (context) => HomeScreen(title: title),
        // kMaterialPurchase: (context) => MaterialPurchase(),
        kMaterialPurchaseEntry: (context) => MaterialPurchaseEntry(),
        kConfigScreen: (context) => ConfigScreen(),
        kAddSuppliersScreen: (context) =>
            AddSuppliersScreen(title: "Add Suppliers"),
        kExistingSuppliersScreen: (context) => ExistingSuppliersScreen(),
        kAddMaterialScreen: (context) =>
            AddMaterialScreen(title: "Add Material"),
        kExistingMaterialScreen: (context) => ExistingMaterialsScreen(),
        kAddEmployeeScreen: (context) =>
            AddEmployeeScreen(title: "Add Employee"),
      },
      title: title,
      theme: ThemeData(
        iconTheme: IconThemeData(color: kIconColor),
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(title: title),
    );
  }
}
