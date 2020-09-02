import 'package:flutter/material.dart';
import 'package:hb_mobile/view/view.dart';

import 'constant.dart';

/*
*   Task:
*   MaterialPurchase
* */
void main() {
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
        kMaterialPurchase: (context) => MaterialPurchase(),
        kMaterialPurchaseEntry: (context) => MaterialPurchaseEntry(),
        kConfigScreen: (context) => ConfigScreen(),
        kAddSuppliers: (context) => AddSuppliersScreen(),
        kExistingSuppliersScreen: (context) => ExistingSuppliersScreen(),
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
