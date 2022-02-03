import 'package:ahia_deliveryAgent/Pages/HomeScreen.dart';
import 'package:ahia_deliveryAgent/Pages/Registration.dart';
import 'package:ahia_deliveryAgent/Pages/ResetPassword.dart';
import 'package:ahia_deliveryAgent/Providers/AuthProvider.dart';
import 'package:ahia_deliveryAgent/Services/FirebaseServices.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  String email;
  String password;

  Icon icon;
  bool _visible = false;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    scaffoldMessage(message) {
      return Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                          Text('LOGIN',
                              style:
                                  TextStyle(fontFamily: 'Anton', fontSize: 20)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: _emailTextController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your email';
                            }
                            final bool _isValidEmail = EmailValidator.validate(
                                _emailTextController.text);
                            if (!_isValidEmail) {
                              return 'Invalid Email';
                            }
                            setState(() {
                              email = value;
                            });
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            focusColor: Theme.of(context).primaryColor,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length <= 6) {
                              return 'Password must be more than six characters';
                            }
                            setState(() {
                              password = value;
                            });
                            return null;
                          },
                          obscureText: _visible == true ? false : true,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: _visible
                                  ? Icon(Icons.remove_red_eye_outlined)
                                  : Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _visible = !_visible;
                                });
                              },
                            ),
                            enabledBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.vpn_key_outlined),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            focusColor: Theme.of(context).primaryColor,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         Navigator.pushNamed(context, ResetPassword.id);
                      //       },
                      //       child: Text('Forgot Password? ',
                      //           textAlign: TextAlign.end,
                      //           style: TextStyle(
                      //               color: Colors.blue,
                      //               fontWeight: FontWeight.bold)),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FlatButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  EasyLoading.show(status: 'Please wait...');
                                  _services.validateUser(email).then((value) {
                                    if (value.exists) {
                                      if (value.data()['password'] ==
                                          password) {
                                        EasyLoading.show(
                                            status: 'Logging you in');
                                        _authData
                                            .loginDeliveryAgent(email, password)
                                            .then((credential) {
                                          if (credential != null) {
                                            EasyLoading.showSuccess(
                                                    'Logged in successfully')
                                                .then((value) {
                                              Navigator.pushReplacementNamed(
                                                  context, HomeScreen.id);
                                            });
                                          } else {
                                            EasyLoading.showInfo(
                                                    'You must register first')
                                                .then((value) {
                                              _authData.getEmail(email);
                                              Navigator.pushNamed(
                                                  context, RegisterScreen.id);
                                            });
                                            // scaffoldMessage(_authData.error);
                                          }
                                        });
                                        EasyLoading.dismiss();
                                      } else {
                                        EasyLoading.showError(
                                            'Invalid credentials');
                                      }
                                    } else {
                                      EasyLoading.showError(
                                          '$email does not exist');
                                    }
                                  });
                                }
                              },
                              child: Text('Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
