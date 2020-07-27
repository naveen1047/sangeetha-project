import 'package:flutter/material.dart';

import 'widgets/common_widgets.dart';
import 'constant.dart';

/*
*   Task:
*   MaterialPurchase
* */
void main() {
  runApp(MyApp(
    title: 'Sangeetha groups',
  ));
}

class MyApp extends StatelessWidget {
  final String title;

  const MyApp({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: kHome,
      routes: {
        kHome: (context) => Dashboard(title: title),
        kMaterialPurchase: (context) => MaterialPurchase(),
        kMaterialPurchaseEntry: (context) => MaterialPurchaseEntry(),
        kConfigScreen: (context) => ConfigScreen(),
        kAddSuppliers: (context) => AddSuppliersScreen(),
      },
      title: title,
      theme: ThemeData(
        iconTheme: IconThemeData(color: kIconColor),
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Dashboard(title: title),
    );
  }
}

class Dashboard extends StatelessWidget {
  final String title;

  const Dashboard({Key key, this.title}) : super(key: key);
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
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
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, kConfigScreen);
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.account_circle,
                            color: Colors.white,
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
      body: ListView(
        children: [
          CategoryLabel(
            title: 'Hollow Block',
            subTitle: 'DashBoard',
            fontSize: 18.0,
          ),
          CategoryCard(
            title: 'Material Purchase',
            titleIcon: Icons.note,
            subTitle: 'Entry',
            subTitleIcon: Icons.edit,
            backgroundColor: Colors.green,
            onTap: () {
              Navigator.pushNamed(context, kMaterialPurchase);
            },
          ),
          CategoryCard(
            title: 'Material Purchase',
            titleIcon: Icons.note,
            subTitle: 'Report',
            subTitleIcon: Icons.description,
            backgroundColor: Colors.grey,
          ),
          CategoryCard(
            title: 'Production',
            titleIcon: Icons.add_circle,
            subTitle: 'Entry',
            subTitleIcon: Icons.edit,
            backgroundColor: Colors.amber,
          ),
          CategoryCard(
            title: 'Production',
            titleIcon: Icons.add_circle,
            subTitle: 'Report',
            subTitleIcon: Icons.description,
            backgroundColor: Colors.deepOrange,
          ),
          CategoryCard(
            title: 'Sales',
            titleIcon: Icons.trending_up,
            subTitle: 'Entry',
            subTitleIcon: Icons.edit,
            backgroundColor: Colors.blue,
          ),
          CategoryCard(
            title: 'Sales',
            titleIcon: Icons.trending_up,
            subTitle: 'Report',
            subTitleIcon: Icons.description,
            backgroundColor: Colors.pinkAccent,
          ),
          CategoryCard(
            title: 'Payment',
            titleIcon: Icons.attach_money,
            subTitle: 'sales',
            subTitleIcon: Icons.trending_up,
            backgroundColor: Colors.brown,
          ),
          CategoryCard(
            title: 'Payment',
            titleIcon: Icons.attach_money,
            subTitle: 'Client',
            subTitleIcon: Icons.person_outline,
            backgroundColor: Colors.lightGreen,
          ),
          CategoryCard(
            title: 'Stock',
            titleIcon: Icons.access_time,
            subTitle: 'Detail',
//            subTitleIcon: Icons.description,
            backgroundColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}

class MaterialPurchase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Purchase'),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, kMaterialPurchaseEntry);
        },
        label: Text('Entry'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}

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
              textField: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Bill Number',
                ),
              ),
              iconData: Icons.receipt,
            ),
            //TODO: add supliers and material dropDown
            InputField(
              textField: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Quantity',
                ),
              ),
              iconData: Icons.edit,
            ),
            //TODO: add unit dropDown
            InputField(
              textField: TextField(
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

class ConfigScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Config'),
      ),
      body: ListView(
        children: [
          DualButton(
            title: 'Add Suppliers',
            subtitle: 'Existing suppliers',
            primaryColor: Colors.grey,
            onTapSecondary: () {},
            onTapPrimary: () {
              Navigator.pushNamed(context, kAddSuppliers);
            },
          ),
          DualButton(
            title: 'Add Material',
            subtitle: 'Existing material',
            primaryColor: Colors.amber,
            onTapSecondary: () {},
            onTapPrimary: () {},
          ),
          DualButton(
            title: 'Change price',
            subtitle: 'Already prices material',
            primaryColor: Colors.brown,
            onTapSecondary: () {},
            onTapPrimary: () {},
          ),
        ],
      ),
    );
  }
}

class AddSuppliersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Supliers'),
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
            Padding(
              padding: kTopPadding,
              child: PrimaryActionButton(
                title: 'Upload',
                onPressed: () {},
              ),
            ),
            FlatButton(
              child: Text('View existing suppliers'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
