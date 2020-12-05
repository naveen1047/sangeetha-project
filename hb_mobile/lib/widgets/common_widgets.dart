import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hb_mobile/constant.dart';

// class CategoryCard extends StatelessWidget {
//   final String title;
//   final IconData titleIcon;
//   final String subTitle;
//   // final IconData subTitleIcon;
//   final Color backgroundColor;
//   final Color textColor;
//   final Function onTap;
//
//   const CategoryCard({
//     Key key,
//     this.onTap,
//     @required this.title,
//     this.titleIcon,
//     @required this.subTitle,
//     // this.subTitleIcon,
//     @required this.backgroundColor,
//     this.textColor = const Color(0xFFFFFFFF),
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           decoration: BoxDecoration(
//               color: backgroundColor,
//               borderRadius: BorderRadius.all(Radius.circular(8.0))),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         titleIcon,
//                         color: textColor,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Text(
//                           title,
//                           style: TextStyle(color: textColor),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       // Icon(
//                       //   subTitleIcon,
//                       //   color: textColor,
//                       // ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Text(
//                           subTitle,
//                           style: TextStyle(color: textColor, fontSize: 12.0),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData titleIcon;
  final String subTitle;

  // final IconData subTitleIcon;
  final Color backgroundColor;
  final Color textColor;
  final Function onTap;
  final Function onPressedSecondary;

  const CategoryCard({
    Key key,
    this.onTap,
    @required this.title,
    this.titleIcon,
    @required this.subTitle,
    // this.subTitleIcon,
    @required this.backgroundColor,
    this.textColor,
    this.onPressedSecondary,
    // this.textColor = const Color(0xFFFFFFFF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: kMutedColor),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Icon(
                      titleIcon,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        subTitle,
                        style: TextStyle(color: kTextColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0.0,
          ),
          FlatButton(
            onPressed: onPressedSecondary,
            child: Text(
              '+ ADD',
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          )
        ],
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

class MenuTitle extends StatelessWidget {
  final String title;

  const MenuTitle({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(color: kIconColor),
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
          iconData != null
              ? Icon(
                  iconData,
                  color: Colors.black54,
                )
              : Container(),
          Padding(
            padding: kIconLeftPadding,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

/// Should provide 'isDisabled = false'
/// to disable the inputField
class InputField extends StatelessWidget {
  final Widget child;
  final IconData iconData;
  final bool isDisabled;
  final Widget trailing;
  final String tooltip;

  const InputField({
    Key key,
    @required this.child,
    this.iconData,
    this.isDisabled = false,
    this.trailing,
    @required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kTopPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Tooltip(
            message: tooltip == null ? "" : tooltip,
            child: Container(
              decoration: kOutBdrDisabledDecoration,
              child: Padding(
                padding: kFieldPadding,
                child: Icon(
                  iconData,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              decoration: isDisabled
                  ? kOutBdrDisabledDecoration
                  : kOutlineBorderDecoration,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: child,
              ),
            ),
          ),
          trailing != null ? trailing : Container(),
        ],
      ),
    );
  }
}

// class DualButton extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final Function onTapPrimary;
//   final Function onTapSecondary;
//   final Color primaryColor;
//
//   const DualButton({
//     Key key,
//     @required this.title,
//     @required this.subtitle,
//     @required this.onTapPrimary,
//     @required this.onTapSecondary,
//     @required this.primaryColor,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Padding(
//         padding: kPrimaryPadding,
//         child: Container(
//           decoration: kDualButtonDecoration,
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: onTapPrimary,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(4.0)),
//                     color: primaryColor,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             title,
//                             style: TextStyle(
//                               color: kWhiteColor,
//                               fontSize: 20.0,
//                             ),
//                           ),
//                         ),
//                         Icon(
//                           Icons.keyboard_arrow_right,
//                           color: kWhiteColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               // TODO: sliding issue
//               GestureDetector(
//                 onTap: onTapSecondary,
//                 child: Container(
//                   // color: Colors.blue,
//                   child: Padding(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Row(
//                       children: [
//                         Icon(Icons.folder_open),
//                         SizedBox(width: 4.0),
//                         Expanded(child: Text(subtitle)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class PrimaryActionButton extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPressed;

  const PrimaryActionButton(
      {Key key,
      @required this.title,
      this.color = kPrimaryAccentColor,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(color: kWhiteColor),
      ),
    );
  }
}

SnackBar warningSnackBar({@required String message, Widget widget}) {
  return SnackBar(
    duration: Duration(seconds: 2),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            '${message}',
            softWrap: true,
          ),
        ),
        widget != null ? widget : Icon(Icons.info),
      ],
    ),
    backgroundColor: Colors.red,
  );
}

/// For positive result
SnackBar progressSnackBar({
  @required String message,
  Widget child,
  int seconds = 2,
}) {
  return SnackBar(
    duration: Duration(seconds: seconds),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            '${message}',
            softWrap: true,
          ),
        ),
        child != null
            ? child
            : Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
      ],
    ),
  );
}

Widget message(String message, {Widget child}) {
  return Padding(
    padding: kPrimaryPadding,
    child: _label(message, child: child),
  );
}

Row _label(String message, {Widget child}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Text(
          '${message}',
          softWrap: true,
        ),
      ),
      child != null
          ? child
          : Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
    ],
  );
}

Widget datatableLabel(String message, {bool isSortable = false}) {
  if (isSortable) {
    return Row(
      children: [
        Text(
          message,
          style: kDatatableLabelStyle,
        ),
        Icon(
          Icons.swap_vert,
          color: kPrimaryAccentColor,
        ),
      ],
    );
  }
  return Text(
    message,
    style: kDatatableLabelStyle,
  );
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
        decoration: kCardDecoration,
        child: ListTile(
          title: Text(subtitle),
          onTap: onTapSecondary,
          trailing: IconButton(
            icon: Icon(Icons.add_circle_rounded),
            color: kPrimaryAccentColor,
            onPressed: onTapPrimary,
            tooltip: title,
          ),
          tileColor: kMutedColorLight,
        ),
      ),
    );
  }
}

class SecondaryActionButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  const SecondaryActionButton({Key key, this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        title,
        style: TextStyle(color: kTextColor),
      ),
      onPressed: () {
        Navigator.pushNamed(context, kExistingProductScreen);
      },
    );
  }
}

class DropdownDecorator extends StatelessWidget {
  final Widget child;

  const DropdownDecorator({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kTopPadding,
      child: Container(
        padding: kHorizontalPadding,
        decoration: kOutlineBorderDecoration,
        child: child,
      ),
    );
  }
}

DataCell dataCellDecorator(String text) {
  return DataCell(Text(
    text,
    style: kDatatableCellStyle,
  ));
}
