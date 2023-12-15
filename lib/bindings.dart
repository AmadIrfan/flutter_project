import '/features/home/home_controller.dart';
import '/features/home/theme_controller.dart';
import '/features/login_singup/controllers/auth_controller.dart';

import 'package:get/get.dart';

import 'features/user profile/profile_controller.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ThemeController>(() => ThemeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
