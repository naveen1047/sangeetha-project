import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/simple_bloc_observer.dart';
import 'package:hb_mobile/view/add_customer_view.dart';
import 'package:hb_mobile/view/add_product_view.dart';
import 'package:hb_mobile/view/existing_customer_view.dart';
import 'package:hb_mobile/view/existing_material_view.dart';
import 'package:hb_mobile/view/existing_product_view.dart';
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
        kAddMaterialPurchase: (context) => AddMaterialPurchaseScreen(),
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
      },
      title: title,
      theme: MaterialDemoThemeData.themeData,
      home: HomeScreen(title: title),
    );
  }
}

class MaterialDemoThemeData {
  static final themeData = ThemeData(
    colorScheme: _colorScheme,
    appBarTheme: AppBarTheme(
      color: _colorScheme.primary,
      iconTheme: IconThemeData(color: _colorScheme.onPrimary),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: _colorScheme.primary,
    ),
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      colorScheme: _colorScheme,
    ),
    canvasColor: _colorScheme.background,
    toggleableActiveColor: _colorScheme.primary,
    highlightColor: Colors.transparent,
    indicatorColor: _colorScheme.onPrimary,
    primaryColor: _colorScheme.primary,
    accentColor: _colorScheme.primary,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: _colorScheme.background,
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
    typography: Typography.material2018(
        // platform: defaultTargetPlatform,
        ),
  );

  static const _colorScheme = ColorScheme(
    primary: Color(0xFF6200EE),
    primaryVariant: Color(0xFF3700B2),
    secondary: Color(0xFF03DAC6),
    secondaryVariant: Color(0xFF018786),
    background: Colors.white,
    surface: Color(0xFFF2F2F2),
    onBackground: Colors.black,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    brightness: Brightness.light,
  );
  // static const _colorScheme = ColorScheme(
  //   primary: Color(0xFF6200EE),
  //   primaryVariant: Color(0xFF6200EE),
  //   secondary: Color(0xFFFF5722),
  //   secondaryVariant: Color(0xFFFF5722),
  //   background: Colors.white,
  //   surface: Color(0xFFF2F2F2),
  //   onBackground: Colors.black,
  //   onSurface: Colors.black,
  //   error: Colors.red,
  //   onError: Colors.white,
  //   onPrimary: Colors.white,
  //   onSecondary: Colors.white,
  //   brightness: Brightness.light,
  // );
}
