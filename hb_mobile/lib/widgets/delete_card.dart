import 'package:flutter/material.dart';

class DeleteCard extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const DeleteCard({Key key, this.title, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(title),
            actions: actions,
          ),
        );
      },
      icon: Icon(Icons.delete),
    );
  }
}
