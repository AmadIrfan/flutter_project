import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  bool isDarkMode = false;

  void changeTheme() {
    // isDarkMode = !isDarkMode;
    if (isDarkMode) {
      Get.changeTheme(ThemeData.light());
    } else {
      Get.changeTheme(ThemeData.dark());
    }
  }
}
