import 'package:flutter/material.dart';

const String kHome = '/dash_board';
const String kMaterialPurchase = '/material_purchase';
const String kMaterialPurchaseEntry = '/material_purchase_entry';
const String kConfigScreen = '/configScreen';
const String kAddSuppliers = '/addSuppliers';
const String kExistingSuppliersScreen = '/existingSuppliersScreen';

//decoration
Decoration kOutlineBorder = BoxDecoration(
  border: Border.all(
    color: kMutedColor,
    width: 1,
  ),
  borderRadius: BorderRadius.circular(4.0),
);

///enabled input field
Decoration kOutlineBorderDisabled = BoxDecoration(
  color: kMutedColorLite,
  border: Border.all(
    color: kMutedColor,
    width: 1,
  ),
  borderRadius: BorderRadius.circular(4.0),
);

//color
const Color kMutedColorLite = Color(0x10000000);
const Color kMutedColor = Color(0x15000000);
const Color kIconColor = Color(0x80000000);
const Color kTextColor = Color(0x80000000);
const Color kWhiteColor = Color(0xFFFFFFFF);

//padding
const kVerticalPadding = const EdgeInsets.symmetric(vertical: 8.0);
const kTopPadding = const EdgeInsets.only(top: 8.0);
const kFieldPadding = const EdgeInsets.all(12.0);
const kPrimaryPadding = const EdgeInsets.all(8.0);
