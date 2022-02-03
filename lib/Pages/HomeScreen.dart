import 'package:ahia_deliveryAgent/Pages/LoginScreen.dart';
import 'package:ahia_deliveryAgent/Services/FirebaseServices.dart';
import 'package:ahia_deliveryAgent/Widget/OrderSummaryCard.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user = FirebaseAuth.instance.currentUser;
  FirebaseServices _services = FirebaseServices();
  String status;

  int tag = 0;
  List<String> options = [
    'All',
    'Accepted',
    'Picked Up',
    'On the way',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
      appBar: AppBar(
          title: Text('Orders', style: TextStyle(color: Colors.white)),
          centerTitle: true),
      body: Column(
        children: [
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              value: tag,
              onChanged: (val) {
                if (val == 0) {
                  setState(() {
                    status = null;
                  });
                }
                setState(() {
                  tag = val;
                  status = options[val];
                });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _services.orders
                .where('deliveryBoy.email', isEqualTo: user.email)
                .where('orderStatus', isEqualTo: tag == 0 ? null : status)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data.size == 0) {
                return Center(
                  child: Text('No $status Orders'),
                );
              }

              return Expanded(
                child: new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: new OrderSummaryCard(document),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Log Out Code
// FlatButton(
//   color: Colors.red,
//   child: Text('Sign Out'),
//   onPressed: () {
//     FirebaseAuth.instance.signOut().whenComplete(() {
//       FirebaseAuth.instance.authStateChanges().listen((User user) {
//         if (user == null) {
//           Navigator.pushReplacementNamed(context, LoginScreen.id);
//         }
//       });
//     });
//   },
// )
