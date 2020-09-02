
import 'package:flutter/material.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class AddSuppliersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Suppliers'),
      ),
      body: Padding(
        padding: kPrimaryPadding,
        child: ListView(
          children: [
            InputField(
              textField: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Supplier Name',
                ),
              ),
              iconData: Icons.person,
            ),
            InputField(
              textField: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Supplier code',
                ),
              ),
              iconData: Icons.info,
              isDisabled: true,
            ),
            InputField(
              textField: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Contact',
                ),
              ),
              iconData: Icons.call,
            ),
            InputField(
              textField: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Address',
                ),
              ),
              iconData: Icons.home,
            ),
            InputField(
              textField: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'current date',
                ),
              ),
              iconData: Icons.date_range,
              isDisabled: true,
            ),
            Padding(
              padding: kTopPadding,
              child: PrimaryActionButton(
                title: 'Upload',
                onPressed: () {},
              ),
            ),
            FlatButton(
              child: Text('View existing suppliers'),
              onPressed: () {
                Navigator.pushNamed(context, kExistingSuppliersScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
