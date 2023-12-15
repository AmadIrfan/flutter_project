import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> onWillPop(context) async {
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to exit the App'),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            MaterialButton(
              onPressed: () => SystemNavigator.pop(),
              child: Text('Yes'),
            ),
          ],
        ),
      )) ??
      false;
}
