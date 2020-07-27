import 'package:flutter/material.dart';
import 'package:hb_mobile/constant.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData titleIcon;
  final String subTitle;
  final IconData subTitleIcon;
  final Color backgroundColor;
  final Color textColor;
  final Function onTap;

  const CategoryCard({
    Key key,
    this.onTap,
    @required this.title,
    this.titleIcon,
    @required this.subTitle,
    this.subTitleIcon,
    @required this.backgroundColor,
    this.textColor = const Color(0xFFFFFFFF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      titleIcon,
                      color: textColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        title,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      subTitleIcon,
                      color: textColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        subTitle,
                        style: TextStyle(color: textColor),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryLabel extends StatelessWidget {
  final String title;
  final String subTitle;
  final double fontSize;

  const CategoryLabel({Key key, this.title, this.subTitle, this.fontSize})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: fontSize),
          ),
          Text(subTitle),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function onTap;

  const MenuItem(
      {Key key, this.iconData, @required this.title, @required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          iconData != null ? Icon(iconData) : Container(),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(title),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

class InputField extends StatelessWidget {
  final TextField textField;
  final IconData iconData;

  const InputField({Key key, @required this.textField, this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kVerticalPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: kOutlineBorder,
            child: Padding(
              padding: kFieldPadding,
              child: Icon(iconData),
            ),
          ),
          Flexible(
            child: Container(
              decoration: kOutlineBorder,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: textField,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
