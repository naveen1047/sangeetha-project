import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:core/core.dart';

class SupplierSearch extends SearchDelegate<Supplier> {
  final List<Supplier> suppliers;

  SupplierSearch(this.suppliers);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var results = suppliers
        .where((s) => s.sname.toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: results
          .map<ListTile>((s) => ListTile(
                title: Text(s.sname,
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontSize: 16.0)),
                leading: Icon(Icons.book),
                // onTap: () async {
                //   if (await canLaunch(a.url)) {
                //     await launch(a.url);
                //   }
                //   close(context, a);
                // },
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = suppliers
        .where((s) => s.sname.toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: results
          .map<ListTile>((s) => ListTile(
                title: Text(s.sname,
                    style: Theme.of(context).textTheme.subhead.copyWith(
                          fontSize: 16.0,
                          color: Colors.blue,
                        )),
                onTap: () {
                  close(context, s);
                },
              ))
          .toList(),
    );
  }
}
