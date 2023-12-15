import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isloggedin = false.obs;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void onInit() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isloggedin.value = false;
      } else {
        isloggedin.value = true;
      }
    });
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    // setState(() {
    //   _connectionStatus = result;
    // });
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      // _snackbar('You Connection restored');
      Get.rawSnackbar(
        margin: EdgeInsets.all(15.0),
        // title: 'You Connection restored.',
        // message: 'You Connection restored',
        messageText: Text(
          "You are online now",
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w400),
        ),
        isDismissible: false,
        backgroundColor: Colors.teal,
        borderRadius: 20.0,
        //  borderWidth: 15.0,
        icon: Icon(
          Icons.wifi_sharp,
          color: Colors.white,
          size: 25.0,
        ),
        duration: Duration(seconds: 4),
      );

      // return true;
    } else {
      // _snackbar('You are currently offline');
      Get.rawSnackbar(
        // title: 'You are currently offline',
        // message: 'You are currently offline',
        messageText: Text(
          'You are currently offline',
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w400),
        ),
        isDismissible: false,
        borderRadius: 25.0,
        margin: EdgeInsets.all(15.0),
        backgroundColor: Colors.teal,
        icon: Icon(
          Icons.wifi_off_sharp,
          color: Colors.white,
          size: 25.0,
        ),
        duration: Duration(seconds: 4),
      );
      // return false;

      //   showDialog(context: context, builder: (context){
      //    return WillPopScope(child: customAlert(), onWillPop: () async => false);
      //  });
    }
  }
}
