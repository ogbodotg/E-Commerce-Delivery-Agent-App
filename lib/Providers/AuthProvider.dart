import 'dart:io';

import 'package:ahia_deliveryAgent/Pages/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider extends ChangeNotifier {
  File image;
  bool isPicked = false;
  String pickerError = '';
  String address;
  String city;
  String state;
  String error = '';
  String email;
  bool loading = false;

  CollectionReference _deliveryAgents =
      FirebaseFirestore.instance.collection('AhiaDelivery');

  getEmail(email) {
    this.email = email;
    notifyListeners();
  }

  //Upload vendor logo/image
  Future<File> getImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'No image selected.';
      notifyListeners();
      print('No image selected.');
    }
    return this.image;
  }

  // Future getCurrentAddress() async {
  //   Location location = new Location();

  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData _locationData;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   _locationData = await location.getLocation();
  //   this.shopLatitude = _locationData.latitude;
  //   this.shopLongitude = _locationData.longitude;
  //   notifyListeners();

  //   final coordinates = new Coordinates(1.10, 45.50);
  //   var _addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var shopAddress = _addresses.first;
  //   this.shopAddress = shopAddress.addressLine;
  //   this.placeName = shopAddress.featureName;
  //   notifyListeners();
  //   return shopAddress;
  // }

  //Register Vendors

  Future<UserCredential> registerDeliveryAgent(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password provided is too weak.';
        notifyListeners();
        print('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'Email already exists.';
        notifyListeners();
        print('The account already exists for that email');
      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  //Login
  Future<UserCredential> loginDeliveryAgent(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  Future<void> resetPassword(email) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  //Save Vendors to DB
  Future<void> saveDeliveryAgentDatatoDb({
    String url,
    String deliveryAgentName,
    String phoneNumber,
    String address,
    String city,
    String state,
    String password,
    context,
  }) {
    User user = FirebaseAuth.instance.currentUser;

    _deliveryAgents.doc(this.email).update({
      'uid': user.uid,
      'password': password,
      'deliveryAgentName': deliveryAgentName,
      'deliveryAgentImage': url,
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'state': state,
      'accountVerified': false,
    }).whenComplete(() {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    });
    return null;
  }
}
