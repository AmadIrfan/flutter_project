import 'package:flutter/material.dart';
import 'package:get/get.dart';

void _rawsnackbar(txt){
  Get.rawSnackbar(
    // message: e.message.toString(),
    messageText: Text(
      txt,
      style: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
  );
}
