import 'package:flutter/material.dart';
import 'package:hb_mobile/constant.dart';

class SearchWidget extends StatelessWidget {
  final Widget child;

  const SearchWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kSearchPadding,
      child: Container(
        decoration: kSearchDecoration,
        child: Padding(
          padding: kLeftPadding,
          child: child,
        ),
      ),
    );
  }
}
