import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_mobile/constant.dart';
import 'package:hb_mobile/widgets/common_widgets.dart';
import 'package:hb_mobile/widgets/delete_card.dart';
// <<<<<<< HEAD
// import 'package:hb_mobile/widgets/delete_card.dart';
// import 'package:hb_mobile/widgets/profile_card.dart';
// import 'package:hb_mobile/widgets/search_bar_widget.dart';
// import 'package:hb_mobile/widgets/customer_bottom_sheet_widget.dart';
// =======
import 'package:hb_mobile/widgets/navigate_back_widget.dart';
import 'package:hb_mobile/widgets/profile_card.dart';
import 'package:hb_mobile/widgets/search_widget.dart';
import 'package:hb_mobile/widgets/customer_bottom_sheet_widget.dart';
// >>>>>>> fixMaterial

// TODO: scroll position to desired position

class ExistingCustomersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              ViewCustomerBloc()..add(FetchCustomerEvent()),
        ),
        BlocProvider(
          create: (BuildContext context) => CustomerBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Existing Customers'),
          leading: NavigateBackButton(),
          actions: [
            CustomerAppbarDropDownMenu(),
          ],
        ),
        body: ExistingCustomersList(),
      ),
    );
  }
}

class CustomerAppbarDropDownMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (choice) {
        choiceAction(choice, context);
      },
      itemBuilder: (BuildContext context) {
        return CustomerConstants.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  void choiceAction(String choice, BuildContext context) {
    if (choice == CustomerConstants.Settings) {
      print('Settings');
    } else if (choice == CustomerConstants.Refresh) {
      BlocProvider.of<ViewCustomerBloc>(context).add(FetchCustomerEvent());
    } else if (choice == CustomerConstants.AddCustomer) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          kAddCustomerScreen, ModalRoute.withName(kConfigScreen));
    }
  }
}

class ExistingCustomersList extends StatefulWidget {
  @override
  _ExistingCustomersListState createState() => _ExistingCustomersListState();
}

class _ExistingCustomersListState extends State<ExistingCustomersList> {
  ViewCustomerBloc _viewCustomerBloc;
  CustomerBloc _editCustomerBloc;

  @override
  void initState() {
    _viewCustomerBloc = BlocProvider.of<ViewCustomerBloc>(context);
    _editCustomerBloc = BlocProvider.of<CustomerBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _viewCustomerBloc?.close();
    _editCustomerBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is CustomerLoading) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  progressSnackBar(
                      message: state.message,
                      seconds: 1,
                      child: CircularProgressIndicator()),
                );
            }
            if (state is CustomerSuccess) {
              _viewCustomerBloc.add(FetchCustomerEvent());
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      '${state.message}',
                      softWrap: true,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
        ),
      ],
      child: BlocBuilder<ViewCustomerBloc, ViewCustomerState>(
        builder: (context, state) {
          if (state is ViewCustomerLoading) {
            return LinearProgressIndicator();
          }
          if (state is ViewCustomerLoaded) {
            final customers = state.customers;

            return _buildCards(state, customers);
          }
          if (state is ViewCustomerError) {
            return _errorMessage(state, context);
          } else {
            return Text('unknown state error please report to developer');
          }
        },
      ),
    );
  }

  Widget _buildCards(ViewCustomerLoaded state, List<Customer> customers) {
    return Column(
      children: [
        SizedBox(height: 8.0),
        SearchWidget(
          child: TextField(
            style: TextStyle(color: Colors.white),
            onChanged: (query) => _viewCustomerBloc
                .add(SearchAndFetchCustomerEvent(cname: query)),
            decoration: kSearchTextFieldDecoration,
          ),
        ),
        SizedBox(height: 8.0),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1));
              _viewCustomerBloc.add(FetchCustomerEvent());
            },
            child: _buildCardList(state, customers),
          ),
        ),
      ],
    );
  }

  Widget _buildCardList(ViewCustomerLoaded state, List<Customer> customers) {
    if (customers.length == 0) {
      return Center(child: Text("no results found"));
    }
    return ListView.builder(
      itemCount: state.customers.length,
      itemBuilder: (context, index) {
        return _buildCard(customers, index, context);
      },
    );
  }

  Widget _buildCard(List<Customer> customers, int index, BuildContext context) {
    return ProfileCard(
      cardKey: "${customers[index].ccode}",
      title: "${customers[index].cname}",
      subtitle: "${customers[index].cnum}",
      date: "${customers[index].caddate}",
      id: "${customers[index].ccode}",
      detail: "${customers[index].caddress}",
      editCard: _editCard(context, customers, index),
      deleteCard: _deleteCard(context, customers, index),
    );
  }

  Widget _deleteCard(
      BuildContext context, List<Customer> customers, int index) {
    return DeleteCard(
      title: 'Are you sure you want to delete "${customers[index].cname}"?',
      actions: [
        FlatButton(
            onPressed: () {
              _editCustomerBloc
                  .add(DeleteCustomer(ccode: customers[index].ccode));
              Navigator.pop(context);
            },
            child: Text('Yes')),
        FlatButton(onPressed: () => Navigator.pop(context), child: Text('No')),
      ],
    );
  }

  IconButton _editCard(
      BuildContext context, List<Customer> customers, int index) {
    return IconButton(
      onPressed: () {
        _showModalBottomSheet(context, customers, index);
      },
      icon: Icon(Icons.edit),
    );
  }

  Future<void> _showModalBottomSheet(
      BuildContext context, List<Customer> customers, int index) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: BlocProvider(
              create: (BuildContext context) => CustomerBloc(),
              child: CustomerBottomSheet(
                viewCustomerBloc: _viewCustomerBloc,
                customerCode: customers[index].ccode,
                customerContact: customers[index].cnum,
                customerName: customers[index].cname,
                customerAddress: customers[index].caddress,
              ),
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  Widget _errorMessage(ViewCustomerError state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${state.message}'),
          RaisedButton(
              onPressed: () {
                BlocProvider.of<ViewCustomerBloc>(context)
                    .add(FetchCustomerEvent());
              },
              child: Text('refresh')),
        ],
      ),
    );
  }
}
// <<<<<<< HEAD
// =======
//
// class CustomerBottomSheet extends StatefulWidget {
//   final viewCustomerBloc;
//   final String customerCode;
//   final String customerName;
//   final String customerContact;
//   final String customerAddress;
//
//   const CustomerBottomSheet({
//     Key key,
//     @required this.customerCode,
//     @required this.customerName,
//     @required this.customerContact,
//     @required this.customerAddress,
//     this.viewCustomerBloc,
//   }) : super(key: key);
//
//   @override
//   _BottomSheetState createState() => _BottomSheetState();
// }
//
// class _BottomSheetState extends State<CustomerBottomSheet> {
//   CustomerBloc _addCustomerBloc;
//   TextEditingController _customerNameController;
//   TextEditingController _customerCodeController;
//   TextEditingController _contactController;
//   TextEditingController _addressController;
//   TextEditingController _addDateController;
//
//   @override
//   void initState() {
//     _addCustomerBloc = BlocProvider.of<CustomerBloc>(context);
//     _customerNameController = TextEditingController();
//     _customerCodeController = TextEditingController();
//     _contactController = TextEditingController();
//     _addressController = TextEditingController();
//     _addDateController = TextEditingController();
//     setValues();
//     super.initState();
//   }
//
//   void setValues() {
//     _customerCodeController.text = widget.customerCode;
//     _customerNameController.text = widget.customerName;
//     _contactController.text = widget.customerContact;
//     _addressController.text = widget.customerAddress;
//     _addDateController.text = _addCustomerBloc.getDateInFormat;
//   }
//
//   @override
//   void dispose() async {
//     _customerNameController.dispose();
//     _customerCodeController.dispose();
//     _contactController.dispose();
//     _addressController.dispose();
//     _addDateController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: kPrimaryPadding,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           BlocListener<CustomerBloc, CustomerState>(
//             listener: (context, state) async {
//               if (state is CustomerSuccess) {
//                 await Future.delayed(Duration(seconds: 1));
//                 widget.viewCustomerBloc.add(FetchCustomerEvent());
//                 Navigator.pop(context);
//               }
//             },
//             child: BlocBuilder<CustomerBloc, CustomerState>(
//               builder: (context, state) {
//                 if (state is CustomerSuccess) {
//                   return message("Value changed successfully");
//                 }
//                 if (state is CustomerLoading) {
//                   return message(
//                     "Updating...",
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 if (state is CustomerError) {
//                   return _errorMessage(state);
//                 } else {
//                   return _bottomTitle();
//                 }
//               },
//             ),
//           ),
//           _buildCodeField(),
//           _buildDateField(),
//           _buildNameField(),
//           _buildContactField(),
//           _buildAddressField(),
//           _buildActionButtons(context),
//         ],
//       ),
//     );
//   }
//
//   Padding _buildActionButtons(BuildContext context) {
//     return Padding(
//       padding: kPrimaryPadding,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           PrimaryActionButton(
//             title: 'Change',
//             onPressed: () {
//               uploadData();
//             },
//           ),
//           PrimaryActionButton(
//             title: 'Cancel',
//             onPressed: () => Navigator.pop(context),
//             color: kSecondaryColor,
//           ),
//         ],
//       ),
//     );
//   }
//
//   void uploadData() {
//     _addCustomerBloc
//       ..add(
//         EditCustomer(
//           cname: _customerNameController.text,
//           saddate: _addDateController.text,
//           saddress: _addressController.text,
//           scode: _customerCodeController.text,
//           snum: _contactController.text,
//         ),
//       );
//   }
//
//   InputField _buildAddressField() {
//     return InputField(
//       child: TextField(
//         minLines: 1,
//         maxLines: 2,
//         controller: _addressController,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: 'Address',
//         ),
//       ),
//       iconData: Icons.home,
//     );
//   }
//
//   InputField _buildContactField() {
//     return InputField(
//       child: TextField(
//         controller: _contactController,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: 'Contact',
//         ),
//       ),
//       iconData: Icons.call,
//     );
//   }
//
//   InputField _buildNameField() {
//     return InputField(
//       child: TextField(
//         controller: _customerNameController,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: 'Name',
//         ),
//       ),
//       iconData: Icons.person,
//     );
//   }
//
//   InputField _buildDateField() {
//     return InputField(
//       child: TextField(
//         enabled: false,
//         controller: _addDateController,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: 'Date',
//         ),
//       ),
//       iconData: Icons.calendar_today,
//       isDisabled: true,
//     );
//   }
//
//   InputField _buildCodeField() {
//     return InputField(
//       child: TextField(
//         enabled: false,
//         controller: _customerCodeController,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: 'Customer code',
//         ),
//       ),
//       iconData: Icons.info,
//       isDisabled: true,
//     );
//   }
//
//   Padding _bottomTitle() {
//     return Padding(
//       padding: kPrimaryPadding,
//       child: Text(
//         'Edit Customer',
//         style: TextStyle(
//           fontSize: 16.0,
//         ),
//       ),
//     );
//   }
//
//   Padding _errorMessage(CustomerError state) {
//     return Padding(
//       padding: kPrimaryPadding,
//       child: Text(
//         '${state.message}',
//         style: TextStyle(
//           color: Colors.red,
//         ),
//       ),
//     );
//   }
// }
// >>>>>>> fixMaterial
