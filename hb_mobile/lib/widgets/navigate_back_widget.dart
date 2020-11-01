import 'package:flutter/material.dart';

class NavigateBackButton extends StatelessWidget {
  const NavigateBackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back_outlined),
    );
  }
}
