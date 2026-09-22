import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
  apiKey: "AIzaSyBAJlLUSckYqSsZzVcsrlaNqCAoyb_hjPY",
  appId: '1:594649230352:web:0e79810a48733d09bf6e95',
  messagingSenderId: '...',
  projectId: '...',
  authDomain: '...',
  storageBucket: '...',
);

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'PASTE_ANDROID_API_KEY_HERE',
    appId: 'PASTE_ANDROID_APP_ID_HERE',
    messagingSenderId: 'PASTE_SENDER_ID_HERE',
    projectId: 'PASTE_PROJECT_ID_HERE',
    storageBucket: 'PASTE_PROJECT_ID_HERE.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'PASTE_IOS_API_KEY_HERE',
    appId: 'PASTE_IOS_APP_ID_HERE',
    messagingSenderId: 'PASTE_SENDER_ID_HERE',
    projectId: 'PASTE_PROJECT_ID_HERE',
    storageBucket: 'PASTE_PROJECT_ID_HERE.appspot.com',
    iosBundleId: 'PASTE_YOUR_IOS_BUNDLE_ID_HERE',
  );
}