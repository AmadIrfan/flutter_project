import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/login_singup/controllers/auth_controller.dart';

Future<void> logout_func(context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Are you sure?'),
      content: Text('you want to logout?'),
      actions: <Widget>[
        MaterialButton(
          onPressed: () => Navigator.pop(context),
          child: Text('No'),
        ),
        MaterialButton(
          onPressed: () async {
            final AuthController _authController = Get.find<AuthController>();
            _authController.signOut();
            Navigator.pop(context);
          },
          child: Text('Yes'),
        ),
      ],
    ),
  );
}
