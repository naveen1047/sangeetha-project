import 'package:flutter/material.dart';
import 'package:hb_mobile/constant.dart';

class SearchBar extends StatelessWidget {
  final String hintText;
  final void Function(String) onChanged;

  const SearchBar({Key key, this.hintText = "Search", this.onChanged})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kSearchPadding,
      child: Container(
        decoration: kSearchDecoration,
        child: Padding(
          padding: kLeftPadding,
          child: TextField(
            style: TextStyle(color: Colors.white),
            onChanged: onChanged,
            decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: InputBorder.none,
                hintText: hintText),
          ),
        ),
      ),
    );
  }
}
