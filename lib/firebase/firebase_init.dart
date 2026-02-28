import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

Future<void> initFirebase() async {
  await Firebase.initializeApp();
  final messaging = FirebaseMessaging.instance;
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    await messaging.requestPermission(alert: true, badge: true, sound: true);
  }
  // MessagingService will be registered in DI after this
}

/// Call from main.dart to set up background handler (top-level).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message if needed
}
