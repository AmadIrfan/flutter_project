// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCkjX_dCBK0oIxVo2QFBdI8g_VNa8GPrNQ',
    appId: '1:184455833230:web:c99203a248fd92d3c78bdf',
    messagingSenderId: '184455833230',
    projectId: 'cricket-app-e9a76',
    authDomain: 'cricket-app-e9a76.firebaseapp.com',
    storageBucket: 'cricket-app-e9a76.appspot.com',
    measurementId: 'G-Y4FHTSXK18',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA3emSWxgIJ4Ds1Y3OHJyMj-AQsQnXbnEM',
    appId: '1:184455833230:android:4ed6ec6574ae4363c78bdf',
    messagingSenderId: '184455833230',
    projectId: 'cricket-app-e9a76',
    storageBucket: 'cricket-app-e9a76.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCnigUwPTlf9XgpBpbMHopXhj_lgZeTtDY',
    appId: '1:184455833230:ios:b7302d0fed902530c78bdf',
    messagingSenderId: '184455833230',
    projectId: 'cricket-app-e9a76',
    storageBucket: 'cricket-app-e9a76.appspot.com',
    iosBundleId: 'com.example.cricketApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCnigUwPTlf9XgpBpbMHopXhj_lgZeTtDY',
    appId: '1:184455833230:ios:624108a2805a98e6c78bdf',
    messagingSenderId: '184455833230',
    projectId: 'cricket-app-e9a76',
    storageBucket: 'cricket-app-e9a76.appspot.com',
    iosBundleId: 'com.example.cricketApp.RunnerTests',
  );
}
