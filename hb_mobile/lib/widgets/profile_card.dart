import 'package:flutter/material.dart';
import 'package:hb_mobile/constant.dart';

class ProfileCard extends StatelessWidget {
  final String cardKey;
  // final int index;
  final String title;
  final String subtitle;
  final String date;
  final String detail;
  final String id;
  final List<Object> object;
  final Widget editCard;
  final Widget deleteCard;

  const ProfileCard({
    Key key,
    this.cardKey,
    // this.index,
    this.object,
    this.title,
    this.subtitle,
    this.detail,
    this.editCard,
    this.deleteCard,
    this.id,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kCardPadding,
      child: Container(
        decoration: kCardDecoration,
        child: ExpansionTile(
          key: Key(cardKey),
          title: _titleCard(context, title),
          subtitle: _subtitleCard(subtitle),
          children: [
            _addressCard(detail),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _idCard(id),
                    _dateLabel(date),
                  ],
                ),
                Row(
                  children: [
                    editCard,
                    deleteCard,
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding _titleCard(BuildContext context, String title) {
    return Padding(
      padding: kBottomPadding,
      child: Row(
        children: [
          Padding(
            padding: kRightPadding,
            child: Icon(
              Icons.account_circle,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(title),
        ],
      ),
    );
  }

  Row _subtitleCard(String title) {
    return Row(
      children: [
        Row(
          children: [
            Padding(
              padding: kRightPadding,
              child: Icon(
                Icons.call,
                color: kSecondaryColor,
              ),
            ),
            Text(title),
          ],
        ),
      ],
    );
  }

  Padding _addressCard(String title) {
    return Padding(
      padding: kHorizontalPadding,
      child: Row(
        children: [
          Padding(
            padding: kRightPadding,
            child: Icon(Icons.home),
          ),
          Flexible(
            child: Text(title),
          ),
        ],
      ),
    );
  }

  Padding _idCard(String title) {
    return Padding(
      padding: kHorizontalPadding,
      child: Row(
        children: [
          Padding(
            padding: kRightPadding,
            child: Icon(Icons.info),
          ),
          Text(title),
        ],
      ),
    );
  }

  Padding _dateLabel(String title) {
    return Padding(
      padding: kRightPadding,
      child: Text(
        title,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
