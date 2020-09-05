import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hb_mobile/constant.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData titleIcon;
  final String subTitle;
  // final IconData subTitleIcon;
  final Color backgroundColor;
  final Color textColor;
  final Function onTap;

  const CategoryCard({
    Key key,
    this.onTap,
    @required this.title,
    this.titleIcon,
    @required this.subTitle,
    // this.subTitleIcon,
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
                    // Icon(
                    //   subTitleIcon,
                    //   color: textColor,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        subTitle,
                        style: TextStyle(color: textColor, fontSize: 12.0),
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

///Should provide 'isDisabled = false'
///to disable the inputField
class InputField extends StatelessWidget {
  final TextField textField;
  final IconData iconData;
  final bool isDisabled;

  const InputField(
      {Key key,
      @required this.textField,
      this.iconData,
      this.isDisabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kTopPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: kOutlineBorderDisabled,
            child: Padding(
              padding: kFieldPadding,
              child: Icon(iconData),
            ),
          ),
          Flexible(
            child: Container(
              decoration: isDisabled ? kOutlineBorderDisabled : kOutlineBorder,
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

class DualButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onTapPrimary;
  final Function onTapSecondary;
  final Color primaryColor;

  const DualButton({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.onTapPrimary,
    @required this.onTapSecondary,
    @required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: kMutedColor,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: onTapPrimary,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 22.0,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: kWhiteColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onTapSecondary,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Icon(Icons.folder_open),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(subtitle),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrimaryActionButton extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPressed;

  const PrimaryActionButton(
      {Key key,
      @required this.title,
      this.color = Colors.green,
      @required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color,
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(color: kWhiteColor),
      ),
    );
  }
}
