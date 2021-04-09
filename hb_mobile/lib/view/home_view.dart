import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/theme.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  final String title;

  const HomeScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text(title),
      ),
      body: CustomScrollView(
        slivers: [
          FloatingAppbar(),
          buildHomeList(context, MediaQuery.of(context).orientation),
        ],
      ),
    );
  }

  Widget buildHomeList(BuildContext context, Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return SliverPadding(
        padding: kPrimaryLitePadding,
        sliver: SliverList(
          delegate: SliverChildListDelegate(categories(context)),
        ),
      );
    } else {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 100.0),
        sliver: SliverList(
          delegate: SliverChildListDelegate(categories(context)),
        ),
      );
    }
  }

  List<Widget> categories(BuildContext context) {
    return [
      CategoryLabel(
        title: 'Hollow Block',
        subTitle: 'DashBoard',
        fontSize: 18.0,
      ),
      CategoryCard(
        title: 'Material Purchase',
        titleIcon: Icons.note,
        subTitle: 'add and edit materials purchase',
        // subTitleIcon: Icons.edit,
        // backgroundColor: Colors.green,
        onTap: () {
          Navigator.pushNamed(context, kExistingMaterialPurchase);
        },
        onPressedSecondary: () =>
            Navigator.pushNamed(context, kAddMaterialPurchase),
      ),
      CategoryCard(
        title: 'Production',
        titleIcon: Icons.add_circle,
        subTitle: 'view production done and change production',
        onTap: () => Navigator.pushNamed(context, kExistingProductionScreen),
        onPressedSecondary: () =>
            Navigator.pushNamed(context, kAddProductionScreen),
        // subTitleIcon: Icons.description,
        // backgroundColor: Colors.deepOrange,
      ),
      CategoryCard(
        title: 'Stock Detail',
        titleIcon: Icons.pie_chart,
        subTitle: 'view existing stock or edit stock',
        onTap: () {
          Navigator.pushNamed(context, kExistingStock);
        },
        // subTitleIcon: Icons.edit,
        // backgroundColor: Colors.blue,
      ),
      CategoryCard(
        title: 'Sales',
        titleIcon: Icons.trending_up,
        subTitle: 'Entry',
        // subTitleIcon: Icons.edit,
        // backgroundColor: Colors.blue,
      ),
      CategoryCard(
        title: 'Sales',
        titleIcon: Icons.trending_up,
        subTitle: 'Report',
        // subTitleIcon: Icons.description,
        // backgroundColor: Colors.pinkAccent,
      ),
      CategoryCard(
        title: 'Payment',
        titleIcon: Icons.attach_money,
        subTitle: 'sales',
        // subTitleIcon: Icons.trending_up,
        // backgroundColor: Colors.brown,
      ),
      CategoryCard(
        title: 'Payment',
        titleIcon: Icons.attach_money,
        subTitle: 'Client',
        // subTitleIcon: Icons.person_outline,
        // backgroundColor: Colors.lightGreen,
      ),
      CategoryCard(
        title: 'Stock',
        titleIcon: Icons.access_time,
        subTitle: 'Detail',
//            subTitleIcon: Icons.description,
        // backgroundColor: Colors.teal,
      ),
    ];
  }
}

class FloatingAppbar extends StatelessWidget {
  const FloatingAppbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: MaterialDemoThemeData.themeData.scaffoldBackgroundColor,
      floating: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 48.0,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current User: Mohan',
                  style: TextStyle(
                      // color: kTextColor,
                      ),
                ),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.settings,
                          // color: kTextColor,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, kConfigScreen);
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.account_circle,
                          // color: kTextColor,
                        ),
                        onPressed: () {}),
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

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Sangeetha groups'),
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),
          MenuItem(
            title: 'DashBoard',
            onTap: null,
            iconData: Icons.dashboard,
          ),
          Divider(thickness: 1.0),
          MenuTitle(
            title: 'Hollow block',
          ),
          MenuItem(
            title: 'Material Purchase',
            onTap: null,
            iconData: Icons.note,
          ),
          MenuItem(
            title: 'Production',
            onTap: null,
            iconData: Icons.add_circle,
          ),
          MenuItem(
            title: 'Sales',
            onTap: null,
            iconData: Icons.trending_up,
          ),
          MenuItem(
            title: 'Stock Details',
            onTap: null,
            iconData: Icons.pie_chart,
          ),
          MenuItem(
            title: 'Payment',
            onTap: null,
            iconData: Icons.attach_money,
          ),
          MenuItem(
            title: 'Material Purchase',
            onTap: null,
            iconData: Icons.note,
          ),
          Divider(thickness: 1.0),
          MenuTitle(title: 'Menu'),
          MenuItem(
            title: 'Settings',
            onTap: () {},
            iconData: Icons.settings,
          ),
          MenuItem(
            title: 'Logout',
            onTap: null,
            iconData: Icons.exit_to_app,
          ),
        ],
      ),
    );
  }
}
