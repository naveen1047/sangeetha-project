import 'package:flutter/material.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class MaterialPurchaseEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Purchase Entry'),
      ),
      body: Padding(
        padding: kPrimaryPadding,
        child: ListView(
          children: [
            Row(
//            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    decoration: kOutlineBorder,
                    child: Padding(
                      padding: kFieldPadding,
                      child: Icon(Icons.date_range),
                    )),
                Expanded(
                  child: Container(
                    decoration: kOutlineBorder,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('dd-mm-yy'),
                        IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2050));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            InputField(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Bill Number',
                ),
              ),
              iconData: Icons.receipt,
            ),
            //TODO: add supliers and material dropDown
            InputField(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Quantity',
                ),
              ),
              iconData: Icons.edit,
            ),
            //TODO: add unit dropDown
            InputField(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Quantity',
                ),
              ),
              iconData: Icons.attach_money,
            ),
            Padding(
              padding: kVerticalPadding,
              child: Container(
                decoration: kOutlineBorder,
                child: TextField(
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Remarks',
                  ),
                ),
              ),
            ),
            Padding(
              padding: kTopPadding,
              child: PrimaryActionButton(
                title: 'Upload',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
