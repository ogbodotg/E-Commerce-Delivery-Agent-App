import 'dart:async';

import 'package:ahia_deliveryAgent/Pages/HomeScreen.dart';
import 'package:ahia_deliveryAgent/Pages/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        } else {
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Hero(
            tag: 'Ahia logo',
            child: Padding(
              padding: const EdgeInsets.all(100),
              child: Column(
                children: [
                  Text(
                    "Ahia Delivery",
                    style: TextStyle(
                        fontFamily: 'Signatra',
                        fontSize: 65,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    '...at your door step',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
