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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAAJ-tLzYrKFcLl-R84agFplV9Fa66_frU',
    appId: '1:723590759234:web:22a15c58138fd0f0b9fedb',
    messagingSenderId: '723590759234',
    projectId: 'medicinereminder-1f080',
    authDomain: 'medicinereminder-1f080.firebaseapp.com',
    storageBucket: 'medicinereminder-1f080.firebasestorage.app',
    measurementId: 'G-5C3QWVDKFG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDe_6OqA2luIhhl2F_Ah797vzNIkncI0YA',
    appId: '1:723590759234:android:0c33c12c74f83d3eb9fedb',
    messagingSenderId: '723590759234',
    projectId: 'medicinereminder-1f080',
    storageBucket: 'medicinereminder-1f080.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBWxJ_T2vjk1HO2elzJQxKpSIrzAh-ZYuc',
    appId: '1:723590759234:ios:b74d6f4814da32e2b9fedb',
    messagingSenderId: '723590759234',
    projectId: 'medicinereminder-1f080',
    storageBucket: 'medicinereminder-1f080.firebasestorage.app',
    iosBundleId: 'com.example.medicineReminder',
  );
}
