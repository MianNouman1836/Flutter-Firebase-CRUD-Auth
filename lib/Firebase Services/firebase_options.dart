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
    apiKey: 'AIzaSyCJNIbd3uBDdRhbbp2X1fj9H5soVrjFAoQ',
    appId: '1:887835062066:web:450ff9a2a6718d372b312b',
    messagingSenderId: '887835062066',
    projectId: 'fir-series-4e686',
    authDomain: 'fir-series-4e686.firebaseapp.com',
    storageBucket: 'fir-series-4e686.appspot.com',
    measurementId: 'G-B98KDGVB8H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjEH4t4dBrQY49niiEDgT-U3ZlitmjzFs',
    appId: '1:887835062066:android:37ef2a22a3ad3f822b312b',
    messagingSenderId: '887835062066',
    projectId: 'fir-series-4e686',
    storageBucket: 'fir-series-4e686.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBE-TxBjZbcMlqR6qXSDmgpixG28VVQHek',
    appId: '1:887835062066:ios:9284785995cab49e2b312b',
    messagingSenderId: '887835062066',
    projectId: 'fir-series-4e686',
    storageBucket: 'fir-series-4e686.appspot.com',
    iosBundleId: 'com.example.firebasePractice',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBE-TxBjZbcMlqR6qXSDmgpixG28VVQHek',
    appId: '1:887835062066:ios:86571041257d768f2b312b',
    messagingSenderId: '887835062066',
    projectId: 'fir-series-4e686',
    storageBucket: 'fir-series-4e686.appspot.com',
    iosBundleId: 'com.example.firebasePractice.RunnerTests',
  );
}
