import 'package:cloud_firestore/cloud_firestore.dart';

import '/bindings.dart';

import '/firebase_options.dart';

import '/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.testMode = true;
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        //  theme: ThemeData.light().copyWith(

        //  ),
        // themeMode: ThemeMode.system,
        // darkTheme: ThemeData.dark(),
        theme: ThemeData(
          primarySwatch: Colors.teal,
          // primaryColor: Colors.teal,
          // primarySwatch
        ),
        initialRoute: AppRoutes.splash,
        getPages: AppRoutes.routes,
        unknownRoute: AppRoutes.unknownRoute,
        initialBinding: AppBindings(),
        // home: SplashScreen(),
      );
    });
  }
}
