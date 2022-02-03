import 'dart:io';

import 'package:ahia_deliveryAgent/Pages/HomeScreen.dart';
import 'package:ahia_deliveryAgent/Pages/LoginScreen.dart';
import 'package:ahia_deliveryAgent/Providers/AuthProvider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  List<String> _collections = [
    'ABIA',
    'ADAMAWA',
    'AKWA IBOM',
    'ANAMBRA',
    'BAUCHI',
    'BAYELSA',
    'BENUE',
    'BORNO',
    'CROSS RIVER',
    'DELTA',
    'EBONYI',
    'EDO',
    'EKITI',
    'ENUGU',
    'GOMBE',
    'IMO',
    'JIGAWA',
    'KADUNA',
    'KANO',
    'KATSINA',
    'KEBBI',
    'KOGI',
    'KWARA',
    'LAGOS',
    'NASARAWA',
    'NIGER',
    'OGUN',
    'ONDO',
    'OSUN',
    'OYO',
    'PLATEAU',
    'RIVERS',
    'SOKOTO',
    'TARABA',
    'YOBE',
    'ZAMFARA',
    'FCT-ABUJA',
  ];
  String dropdownValue;

  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _confirmPasswordTextController = TextEditingController();
  var _nameTextController = TextEditingController();
  // var _addressTextController = TextEditingController();
  // var _descriptionTextController = TextEditingController();
  String email;
  String password;
  String phoneNumber;
  String deliveryAgentName;
  String address;
  String city;
  String state;
  bool _isLoading = false;

  Icon icon;
  bool _visible = false;

  Future<String> uploadFile(filePath) async {
    File file = File(filePath);
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('uploads/deliveryAgentProfilePic/${_nameTextController.text}')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('uploads/deliveryAgentProfilePic/${_nameTextController.text}')
        .getDownloadURL();

    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    setState(() {
      _emailTextController.text = _authData.email;
      email = _authData.email;
    });
    scaffoldMessage(message) {
      return Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return _isLoading
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        : Form(
            key: _formKey,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Name';
                    }
                    setState(() {
                      _nameTextController.text = value;
                      deliveryAgentName = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Name',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  maxLength: 11,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Phone Number';
                    }
                    setState(() {
                      phoneNumber = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    // prefixText: '+234',
                    prefixIcon: Icon(Icons.phone_android),
                    labelText: 'Phone Number',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  enabled: false,
                  controller: _emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'Enter Email Address';
                  //   }
                  //   final bool _isValidEmail =
                  //       EmailValidator.validate(_emailTextController.text);
                  //   if (!_isValidEmail) {
                  //     return 'Invalid Email';
                  //   }
                  //   setState(() {
                  //     email = value;
                  //   });
                  //   return null;
                  // },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: 'Email Address',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  // obscureText: true,
                  obscureText: _visible == true ? false : true,
                  controller: _passwordTextController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Password';
                    }
                    if (value.length <= 6) {
                      return 'Password must be more than 6 characters';
                    }
                    setState(() {
                      password = value;
                    });

                    return null;
                  },
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
                    prefixIcon: Icon(Icons.vpn_key_outlined),
                    labelText: 'Password',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  // obscureText: true,
                  obscureText: _visible == true ? false : true,
                  controller: _confirmPasswordTextController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Confirm Password';
                    }

                    if (_passwordTextController.text !=
                        _confirmPasswordTextController.text) {
                      return 'Password doesn\'t match';
                    }

                    return null;
                  },
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
                    prefixIcon: Icon(Icons.vpn_key_outlined),
                    labelText: 'Confirm Password',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  // controller: _addressTextController,
                  maxLines: 2,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Add Address Line';
                    }
                    setState(() {
                      address = value;
                    });
                    // if (_authData.shopLatitude == null) {
                    //   return 'Please use the navigation button to locate your shop';
                    // }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_city_outlined),
                    labelText: 'Address',
                    contentPadding: EdgeInsets.zero,
                    // suffixIcon: IconButton(
                    //     icon: Icon(Icons.location_searching),
                    //     onPressed: () {
                    //       _addressTextController.text =
                    //           'Locating...\n Please hold on';
                    //       _authData.getCurrentAddress().then((address) {
                    //         if (address != null) {
                    //           setState(() {
                    //             _addressTextController.text =
                    //                 '${_authData.placeName}\n${_authData.shopAddress}';
                    //           });
                    //         } else {
                    //           Scaffold.of(context).showSnackBar(SnackBar(
                    //               content: Text('Couldn\'t find shop location')));
                    //         }
                    //       });
                    //     }),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  // controller: _addressTextController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Location City';
                    }
                    setState(() {
                      city = value;
                    });
                    // if (_authData.shopLatitude == null) {
                    //   return 'Please use the navigation button to locate your shop';
                    // }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_city_outlined),
                    labelText: 'Location City',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Container(
                child: Row(children: [
                  Text(
                    'Select State',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 10),
                  DropdownButton(
                    hint: Text('Select State'),
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (String value) {
                      setState(() {
                        dropdownValue = value;
                      });
                    },
                    items: _collections
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ]),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(3.0),
              //   child: TextFormField(
              //     // controller: _addressTextController,
              //     validator: (value) {
              //       if (value.isEmpty) {
              //         return 'Location State';
              //       }
              //       setState(() {
              //         state = value;
              //       });

              //       return null;
              //     },
              //     decoration: InputDecoration(
              //       prefixIcon: Icon(Icons.location_city_outlined),
              //       labelText: 'Location State',
              //       contentPadding: EdgeInsets.zero,
              //       enabledBorder: OutlineInputBorder(),
              //       focusedBorder: OutlineInputBorder(
              //           borderSide: BorderSide(
              //         width: 2,
              //         color: Theme.of(context).primaryColor,
              //       )),
              //       focusColor: Theme.of(context).primaryColor,
              //     ),
              //   ),
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
                        if (_authData.isPicked == true) {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            _authData
                                .registerDeliveryAgent(email, password)
                                .then((credential) {
                              if (credential.user.uid != null) {
                                uploadFile(_authData.image.path).then((url) {
                                  if (url != null) {
                                    _authData.saveDeliveryAgentDatatoDb(
                                      url: url,
                                      deliveryAgentName: deliveryAgentName,
                                      phoneNumber: phoneNumber,
                                      address: address,
                                      city: city,
                                      state: dropdownValue,
                                      password: password,
                                      context: context,
                                    );

                                    setState(() {
                                      _isLoading = false;
                                    });
                                  } else {
                                    scaffoldMessage(
                                        'Delivery Agent photo upload failed');
                                  }
                                });
                              }
                            });
                          } else {
                            scaffoldMessage(_authData.error);
                          }
                        } else {
                          scaffoldMessage('Please add Delivery Agent image');
                          // Scaffold.of(context).showSnackBar(
                          //     SnackBar(content: Text('Please add shop image/logo')));
                        }
                      },
                      child: Text('Register',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    child: RichText(
                      text: TextSpan(text: '', children: [
                        TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ]),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                  ),
                ],
              ),
            ]),
          );
  }
}
