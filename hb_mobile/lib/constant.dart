import 'package:flutter/material.dart';

const String kHome = '/dash_board';
const String kMaterialPurchase = '/material_purchase';
const String kMaterialPurchaseEntry = '/material_purchase_entry';

//decoration
Decoration kOutlineBorder = BoxDecoration(
  color: kMutedColorLite,
  border: Border.all(
    color: kMutedColor,
    width: 1,
  ),
  borderRadius: BorderRadius.circular(4.0),
);

//color
const Color kMutedColorLite = Color(0x05000000);
const Color kMutedColor = Color(0x10000000);
const Color kIconColor = Color(0x80000000);
const Color kTextColor = Color(0x80000000);

//padding
const kVerticalPadding = const EdgeInsets.symmetric(vertical: 8.0);
const kFieldPadding = const EdgeInsets.all(12.0);
