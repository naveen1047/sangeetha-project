import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/simple_bloc_observer.dart';
import 'package:hb_mobile/theme.dart';
import 'package:hb_mobile/view/add_customer_view.dart';
import 'package:hb_mobile/view/add_product_view.dart';
import 'package:hb_mobile/view/add_production_view.dart';
import 'package:hb_mobile/view/edit_mp_view.dart';
import 'package:hb_mobile/view/edit_production_view.dart';
import 'package:hb_mobile/view/existing_customer_view.dart';
import 'package:hb_mobile/view/existing_material_view.dart';
import 'package:hb_mobile/view/existing_mp_view.dart';
import 'package:hb_mobile/view/existing_product_view.dart';
import 'package:hb_mobile/view/existing_production_view.dart';
import 'package:hb_mobile/view/view.dart';

import 'constant.dart';

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
        kAddProductionScreen: (context) => AddProductionScreen(),
        kExistingProductionScreen: (context) => ExistingProductionsScreen(),
        kEditProductionScreen: (context) => EditProductionScreen(),
        kAddMaterialPurchase: (context) => AddMaterialPurchaseScreen(),
        kExistingMaterialPurchase: (context) => ExistingMPScreen(),
        kConfigScreen: (context) => ConfigScreen(),
        kAddSuppliersScreen: (context) =>
            AddSuppliersScreen(title: "Add Suppliers"),
        kExistingSuppliersScreen: (context) => ExistingSuppliersScreen(),
        kAddMaterialScreen: (context) =>
            AddMaterialScreen(title: "Add Material"),
        kExistingMaterialScreen: (context) => ExistingMaterialsScreen(),
        kAddEmployeeScreen: (context) =>
            AddEmployeeScreen(title: "Add Employee"),
        kExistingEmployeeScreen: (context) => ExistingEmployeesScreen(),
        kAddProductScreen: (context) => AddProductScreen(
              title: "Add Product",
            ),
        kExistingProductScreen: (context) => ExistingProductsScreen(),
        kAddCustomerScreen: (context) => AddCustomersScreen(
              title: "Add Customer",
            ),
        kExistingCustomerScreen: (context) => ExistingCustomersScreen(),
        kEditMPScreen: (context) => EditMPScreen(),
      },
      title: title,
      theme: MaterialDemoThemeData.themeData,
      home: HomeScreen(title: title),
    );
  }
}
