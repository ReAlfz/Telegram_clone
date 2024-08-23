// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBzRrVzO-d7DXWa_ysy8im227ZopCIDTcQ',
    appId: '1:674821593083:web:ba848d0f3c2e6235455d5e',
    messagingSenderId: '674821593083',
    projectId: 'github-eddce',
    authDomain: 'github-eddce.firebaseapp.com',
    databaseURL: 'https://github-eddce-default-rtdb.firebaseio.com',
    storageBucket: 'github-eddce.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUmBPwc0iLD5hlyxLJgVlHd4K_30b8IyA',
    appId: '1:674821593083:android:3c91d7c30a634b8d455d5e',
    messagingSenderId: '674821593083',
    projectId: 'github-eddce',
    databaseURL: 'https://github-eddce-default-rtdb.firebaseio.com',
    storageBucket: 'github-eddce.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCKriSaqnqNWBKkiDkkgeKL0C39lMzfS0c',
    appId: '1:674821593083:ios:2afb1b9e0a96b457455d5e',
    messagingSenderId: '674821593083',
    projectId: 'github-eddce',
    databaseURL: 'https://github-eddce-default-rtdb.firebaseio.com',
    storageBucket: 'github-eddce.appspot.com',
    iosBundleId: 'realfz.flutter.telegram.telegram',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCKriSaqnqNWBKkiDkkgeKL0C39lMzfS0c',
    appId: '1:674821593083:ios:2afb1b9e0a96b457455d5e',
    messagingSenderId: '674821593083',
    projectId: 'github-eddce',
    databaseURL: 'https://github-eddce-default-rtdb.firebaseio.com',
    storageBucket: 'github-eddce.appspot.com',
    iosBundleId: 'realfz.flutter.telegram.telegram',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBzRrVzO-d7DXWa_ysy8im227ZopCIDTcQ',
    appId: '1:674821593083:web:21eeb13547b6ded2455d5e',
    messagingSenderId: '674821593083',
    projectId: 'github-eddce',
    authDomain: 'github-eddce.firebaseapp.com',
    databaseURL: 'https://github-eddce-default-rtdb.firebaseio.com',
    storageBucket: 'github-eddce.appspot.com',
  );
}
