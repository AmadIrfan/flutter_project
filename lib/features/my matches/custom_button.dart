import "package:flutter/material.dart";

Widget customMaterialButton(btnLabel, btnIcon, onPressedFunc) {
  return SizedBox(
    height: 50,
    width: 150,
    child: MaterialButton(
      color: Colors.teal,
        onPressed: onPressedFunc,
        child: Text(
          btnLabel,
          style: TextStyle(
            color: Colors.white,
          ),
        )),
  );
}
