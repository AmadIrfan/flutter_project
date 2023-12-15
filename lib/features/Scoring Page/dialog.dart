// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class dialog extends StatefulWidget {
  const dialog({Key? key}) : super(key: key);

  @override
  _dialogState createState() => _dialogState();
}
// int _selectedRadio = 0;

class _dialogState extends State<dialog> {
  ValueNotifier<int> _radio = ValueNotifier(0);
  // var _radio = 0;
  // ValueNotifier<int> _radio2 = ValueNotifier(0);

  Widget customRadioButton(title, value, onChangedFunc) {
    return ValueListenableBuilder(
      valueListenable: _radio,
      builder: (context, index, wid) {
        return RadioListTile(
          title: Text(
            title,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 19),
          ),
          value: value,
          groupValue: _radio.value,
          onChanged: onChangedFunc,
        );
      },
    );
  }

  void customdialog(_text, radiotile1, radiotile2) {
    Get.dialog(
       AlertDialog(
            contentPadding: EdgeInsets.zero,
            buttonPadding: EdgeInsets.only(top: 10),
            title: Text(
              _text,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 24),
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Divider(
                thickness: 1.5,
              ),
              radiotile1,
              radiotile2,
              Divider(
                thickness: 1.5,
              ),
            ]),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "CANCEL",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _radio.value = 0;
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "OK",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _radio.value = 0;
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              child: Text("ok"),
              onPressed: () {
                customdialog(
                  "Byes or Leg Byes",
                  customRadioButton("Byes", 1, (newValue) {
                    setState(() {
                      _radio.value = newValue;
                    });
                  }),
                  customRadioButton(
                    "Leg Byes",
                    2,
                    (newValue) {
                      setState(() {
                        _radio.value = newValue;
                      });
                    },
                  ),
                );
              }),
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => dialog()));
              },
              icon: Icon(Icons.ac_unit))
        ],
      ),
    );
  }
}
