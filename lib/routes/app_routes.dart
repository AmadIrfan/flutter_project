import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../features/home/home_page.dart';
import '../features/login_singup/splash_screen.dart';
import '../features/user profile/user_profile.dart';

class AppRoutes {
  static final String splash = '/';
  static final String home = '/home';
  static final String profile = '/profile';

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => UserProfile(),
    ),
  ];

  static final unknownRoute = GetPage(
    name: '/not-found',
    page: () => Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    ),
  );
}
