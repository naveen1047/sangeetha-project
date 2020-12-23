import 'package:flutter/material.dart';
import 'package:hb_mobile/theme.dart';

const String kHome = '/dash_board';
const String kExistingMaterialPurchase = '/existing_material_purchase';
const String kAddMaterialPurchase = '/add_material_purchase';
const String kConfigScreen = '/configScreen';
const String kAddSuppliersScreen = '/addSuppliers';
const String kExistingSuppliersScreen = '/existingSuppliersScreen';
const String kAddMaterialScreen = '/addMaterialScreen';
const String kExistingMaterialScreen = '/existingMaterialScreen';
const String kAddEmployeeScreen = '/addEmployeeScreen';
const String kExistingEmployeeScreen = '/existingEmployeeScreen';
const String kAddProductScreen = '/addProductScreen';
const String kExistingProductScreen = '/existingProductScreen';
const String kAddCustomerScreen = '/addCustomerScreen';
const String kExistingCustomerScreen = '/existingCustomerScreen';
const String kEditMPScreen = '/editMPScreen';

const Text rupee = Text(
  ' \u20B9 ',
  style: TextStyle(fontSize: 20.0),
);

// decoration
Decoration kOutlineBorderDecoration = BoxDecoration(
  border: Border.all(
    color: kMutedColor,
    width: 1,
  ),
  borderRadius: kDefaultBorderRadius,
);

InputDecoration kSearchTextFieldDecoration = InputDecoration(
    hintStyle: TextStyle(color: Colors.white),
    icon: Icon(
      Icons.search,
      color: Colors.white,
    ),
    border: InputBorder.none,
    hintText: 'Search');

Decoration kSearchDecoration = BoxDecoration(
  color: Colors.blueGrey.shade800,
  borderRadius: kDefaultBorderRadius,
  boxShadow: kBoxShadow,
);

Decoration kCardDecoration = BoxDecoration(
  color: MaterialDemoThemeData.themeData.colorScheme.secondary,
  borderRadius: kDefaultBorderRadius,
  boxShadow: kBoxShadow,
);

Decoration kDualButtonDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: kDefaultBorderRadius,
  boxShadow: kBoxShadow,
);

List<BoxShadow> kBoxShadow = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 0.5,
    blurRadius: 2.0,
    offset: Offset(3, 3), // changes position of shadow
  ),
];

// enabled input field
Decoration kOutBdrDisabledDecoration = BoxDecoration(
  color: kMutedColorLight,
  border: Border.all(
    color: kMutedColor,
    width: 1,
  ),
  borderRadius: kDefaultBorderRadius,
);

// data table label style
TextStyle kDatatableLabelStyle = TextStyle(
  fontWeight: FontWeight.bold,
  // color: kPrimaryColor,
  // fontSize: 10.0,
);

TextStyle kDatatableCellStyle = TextStyle(
  // color: kPrimaryColor,
  fontSize: 10.0,
);

// border radius
BorderRadiusGeometry kDefaultBorderRadius = BorderRadius.circular(4.0);

//color
const Color kMutedColorLight = Color(0x10000000);
const Color kMutedColor = Color(0x15000000);
const Color kIconColor = Color(0x80000000);
const Color kTextColor = Color(0x80000000);
const Color kWhiteColor = Color(0xFFFFFFFF);
// ******
// const Color kPrimaryColor = Color(0xff6200EE); //Color(0xFF263238);
// const Color kPLightColor = Color(0xff9e47ff);
// const Color kPDarkColor = Color(0xff0400ba);
// const Color kSecondaryColor = Color(0xff03dac6); //Color(0xFF37474F);
// const Color kSLightColor = Color(0xff66fff9);
// const Color kSDarkColor = Color(0xff00a896);
//
// const Color kPTextColor = Color(0xFFFFFFFF);
// const Color kBackgroundColor = Color(0xFFFFFFFF);
// const Color kSurfaceColor = Color(0xFFFFFFFF);
// const Color kErrorColor = Color(0xFFB00020);
// const Color kOnPrimaryColor = Color(0xFFFFFFFF);
// const Color kOnSecondaryColor = Color(0xFF000000);
// const Color kOnBackgroundColor = Color(0xFF000000);
// const Color kOnSurfaceColor = Color(0xFF000000);
// const Color kOnErrorColor = Color(0xFFFFFFFF);
// *****

const Color kPrimaryAccentColor = Color(0xFF0091EA);
// const Color kErrorColor = Color(0xFFF44336);
const Color kActionIconColor = Color(0xFF007700);

//padding
const kVerticalPadding = const EdgeInsets.symmetric(vertical: 8.0);
const kHorizontalPadding = const EdgeInsets.symmetric(horizontal: 16.0);
const kRightPadding = const EdgeInsets.only(right: 8.0);
const kDoubleRightPadding = const EdgeInsets.only(right: 16.0);
const kLeftPadding = const EdgeInsets.only(left: 8.0);
const kDoubleLeftPadding = const EdgeInsets.only(left: 16.0);
const kTripleLeftPadding = const EdgeInsets.only(left: 24.0);
const kSearchPadding = const EdgeInsets.symmetric(horizontal: 6.0);
const kTopPadding = const EdgeInsets.only(top: 8.0);
const kCardPadding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
const kFieldPadding = const EdgeInsets.all(12.0);
const kPrimaryPadding = const EdgeInsets.all(16.0);
const kBottomPadding = const EdgeInsets.only(bottom: 4.0);
const kIconLeftPadding = const EdgeInsets.only(left: 24.0);

// Supplier constants
class SupplierConstants {
  static const String Refresh = 'Refresh';
  static const String Settings = 'Settings';
  static const String AddSupplier = 'Add Supplier';

  static const List<String> choices = <String>[Refresh, AddSupplier, Settings];
}

// Customer constants
class CustomerConstants {
  static const String Refresh = 'Refresh';
  static const String Settings = 'Settings';
  static const String AddCustomer = 'Add Customer';

  static const List<String> choices = <String>[Refresh, AddCustomer, Settings];
}

// Employee constants
class EmployeeConstants {
  static const String Refresh = 'Refresh';
  static const String Settings = 'Settings';
  static const String AddEmployee = 'Add Employee';

  static const List<String> choices = <String>[Refresh, AddEmployee, Settings];
}

// Material constants
class MaterialConstants {
  static const String Refresh = 'Refresh';
  static const String Settings = 'Settings';
  static const String AddMaterial = 'Add Material';

  static const List<String> choices = <String>[Refresh, AddMaterial, Settings];
}

// MP constants
class MPConstants {
  static const String Refresh = 'Refresh';
  static const String Settings = 'Settings';
  static const String AddMP = 'Add Material purchase';

  static const List<String> choices = <String>[Refresh, AddMP, Settings];
}

// Product constants
class ProductConstants {
  static const String Refresh = 'Refresh';
  static const String Settings = 'Settings';
  static const String AddProduct = 'Add Product';

  static const List<String> choices = <String>[Refresh, AddProduct, Settings];
}
