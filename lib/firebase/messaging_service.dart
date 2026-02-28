import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domino_score/core/di/injection.dart';
import 'package:domino_score/core/utils/constants.dart';
import 'package:domino_score/firebase/firebase_init.dart';
import 'package:domino_score/firebase/firestore_refs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagingService {
  MessagingService(this._prefs);

  final SharedPreferences _prefs;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  late final FirestoreRefs _refs = sl<FirestoreRefs>();

  static void _registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> init() async {
    _registerBackgroundHandler();

    final token = await _messaging.getToken();
    if (token == null) return;

    String deviceId = _prefs.getString(deviceIdKey) ?? '';
    if (deviceId.isEmpty) {
      deviceId = '${Platform.operatingSystem}_${DateTime.now().millisecondsSinceEpoch}';
      await _prefs.setString(deviceIdKey, deviceId);
    }

    await _refs.device(deviceId).set({
      'token': token,
      'platform': Platform.operatingSystem,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
  }

  void _onForegroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      // UI can listen via stream/callback to show SnackBar
    }
  }
}
