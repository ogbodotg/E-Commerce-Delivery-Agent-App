import 'package:ahia_deliveryAgent/Pages/LoginScreen.dart';
import 'package:ahia_deliveryAgent/Providers/AuthProvider.dart';
import 'package:ahia_deliveryAgent/Widget/ImagePicker.dart';
import 'package:ahia_deliveryAgent/Widget/RegistrationForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register-screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Ahia Delivery',
                        style: TextStyle(
                            fontFamily: 'Signatra',
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: Theme.of(context).primaryColor)),
                    SizedBox(height: 20),
                    Text('Delivery Agent Registration',
                        style: TextStyle(fontFamily: 'Anton', fontSize: 20)),
                  ],
                ),
                ShopPicCard(),
                RegisterForm(),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
