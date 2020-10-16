import 'package:flutter/material.dart';

const String kHome = '/dash_board';
const String kMaterialPurchase = '/material_purchase';
const String kMaterialPurchaseEntry = '/material_purchase_entry';
const String kConfigScreen = '/configScreen';
const String kAddSuppliersScreen = '/addSuppliers';
const String kExistingSuppliersScreen = '/existingSuppliersScreen';
const String kAddMaterialScreen = '/addMaterialScreen';
const String kExistingMaterialScreen = '/existingMaterialScreen';
const String kAddEmployeeScreen = '/addEmployeeScreen';
const String kExistingEmployeeScreen = '/existingEmployeeScreen';

// decoration
Decoration kOutlineBorder = BoxDecoration(
  border: Border.all(
    color: kMutedColor,
    width: 1,
  ),
  borderRadius: BorderRadius.circular(4.0),
);

Decoration kSearchDecoration = BoxDecoration(
  color: Colors.blueGrey.shade800,
  borderRadius: BorderRadius.circular(4.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 0.5,
      blurRadius: 2.0,
      offset: Offset(4, 4), // changes position of shadow
    ),
  ],
);

Decoration kCardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(4.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 0.5,
      blurRadius: 2.0,
      offset: Offset(3, 3), // changes position of shadow
    ),
  ],
);

// enabled input field
Decoration kOutlineBorderDisabled = BoxDecoration(
  color: kMutedColorLite,
  border: Border.all(
    color: kMutedColor,
    width: 1,
  ),
  borderRadius: BorderRadius.circular(4.0),
);

// data table label style
TextStyle kDatatableLabelStyle = TextStyle(
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.bold,
);

//color
const Color kMutedColorLite = Color(0x10000000);
const Color kMutedColor = Color(0x15000000);
const Color kIconColor = Color(0x80000000);
const Color kTextColor = Color(0x80000000);
const Color kWhiteColor = Color(0xFFFFFFFF);
const Color kPrimaryColor = Color(0xFF263238);
const Color kSecondaryColor = Color(0xFF37474F);

//padding
const kVerticalPadding = const EdgeInsets.symmetric(vertical: 8.0);
const kHorizontalPadding = const EdgeInsets.symmetric(horizontal: 16.0);
const kRightPadding = const EdgeInsets.only(right: 8.0);
const kLeftPadding = const EdgeInsets.only(left: 8.0);
const kSearchPadding = const EdgeInsets.symmetric(horizontal: 6.0);
const kTopPadding = const EdgeInsets.only(top: 8.0);
const kCardPadding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
const kFieldPadding = const EdgeInsets.all(12.0);
const kPrimaryPadding = const EdgeInsets.all(8.0);
const kBottomPadding = const EdgeInsets.only(bottom: 4.0);
