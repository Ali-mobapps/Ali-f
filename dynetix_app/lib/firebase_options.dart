// File path: lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart';

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
          'DefaultFirebaseOptions have not been configured for linux',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDlnOjIoXP3FOx8p2cpwBpvlCdosI0yYaM',
    appId: '1:4032384676:android:d5ee884f3b0765ec4ba031',
    messagingSenderId: '4032384676',
    projectId: 'dynetix-app',
    authDomain: 'dynetix-app.firebaseapp.com',
    storageBucket: 'dynetix-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlnOjIoXP3FOx8p2cpwBpvlCdosI0yYaM',
    appId: '1:4032384676:android:d5ee884f3b0765ec4ba031',
    messagingSenderId: '4032384676',
    projectId: 'dynetix-app',
    storageBucket: 'dynetix-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlnOjIoXP3FOx8p2cpwBpvlCdosI0yYaM',
    appId: '1:4032384676:android:d5ee884f3b0765ec4ba031',
    messagingSenderId: '4032384676',
    projectId: 'dynetix-app',
    storageBucket: 'dynetix-app.firebasestorage.app',
    iosBundleId: 'com.example.dynetixApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDlnOjIoXP3FOx8p2cpwBpvlCdosI0yYaM',
    appId: '1:4032384676:android:d5ee884f3b0765ec4ba031',
    messagingSenderId: '4032384676',
    projectId: 'dynetix-app',
    storageBucket: 'dynetix-app.firebasestorage.app',
    iosBundleId: 'com.example.dynetixApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDlnOjIoXP3FOx8p2cpwBpvlCdosI0yYaM',
    appId: '1:4032384676:android:d5ee884f3b0765ec4ba031',
    messagingSenderId: '4032384676',
    projectId: 'dynetix-app',
    authDomain: 'dynetix-app.firebaseapp.com',
    storageBucket: 'dynetix-app.firebasestorage.app',
  );
}