import 'package:flutter/material.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  final String title;

  const HomeScreen({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
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
            Text('HOLLOW BLOCK'),
            Divider(),
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
            Text('MENU'),
            Divider(),
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
      ),
      appBar: AppBar(
        title: Text(title),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: kWhiteColor,
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
                          color: kTextColor,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.settings,
                                color: kTextColor,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, kConfigScreen);
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.account_circle,
                                color: kTextColor,
                              ),
                              onPressed: () {}),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              CategoryLabel(
                title: 'Hollow Block',
                subTitle: 'DashBoard',
                fontSize: 18.0,
              ),
              CategoryCard(
                title: 'Material Purchase',
                titleIcon: Icons.note,
                subTitle: 'add and edit materials',
                // subTitleIcon: Icons.edit,
                backgroundColor: Colors.green,
                onTap: () {
                  Navigator.pushNamed(context, kMaterialPurchase);
                },
              ),
              // CategoryCard(
              //   title: 'Material Purchase',
              //   titleIcon: Icons.note,
              //   subTitle: 'Report',
              //   subTitleIcon: Icons.description,
              //   backgroundColor: Colors.grey,
              // ),
              CategoryCard(
                title: 'Production',
                titleIcon: Icons.add_circle,
                subTitle: 'Entry',
                // subTitleIcon: Icons.edit,
                backgroundColor: Colors.amber,
              ),
              CategoryCard(
                title: 'Production',
                titleIcon: Icons.add_circle,
                subTitle: 'Report',
                // subTitleIcon: Icons.description,
                backgroundColor: Colors.deepOrange,
              ),
              CategoryCard(
                title: 'Sales',
                titleIcon: Icons.trending_up,
                subTitle: 'Entry',
                // subTitleIcon: Icons.edit,
                backgroundColor: Colors.blue,
              ),
              CategoryCard(
                title: 'Sales',
                titleIcon: Icons.trending_up,
                subTitle: 'Report',
                // subTitleIcon: Icons.description,
                backgroundColor: Colors.pinkAccent,
              ),
              CategoryCard(
                title: 'Payment',
                titleIcon: Icons.attach_money,
                subTitle: 'sales',
                // subTitleIcon: Icons.trending_up,
                backgroundColor: Colors.brown,
              ),
              CategoryCard(
                title: 'Payment',
                titleIcon: Icons.attach_money,
                subTitle: 'Client',
                // subTitleIcon: Icons.person_outline,
                backgroundColor: Colors.lightGreen,
              ),
              CategoryCard(
                title: 'Stock',
                titleIcon: Icons.access_time,
                subTitle: 'Detail',
//            subTitleIcon: Icons.description,
                backgroundColor: Colors.teal,
              ),
            ]),
          ),
        ],
//        children: [

//        ],
      ),
    );
  }
}
