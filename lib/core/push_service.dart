import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_voip_pushkit/flutter_voip_pushkit.dart';

import 'call_service.dart';

class PushService {
  PushService._();
  static final instance = PushService._();

  final _voip = FlutterVoipPushKit();

  String? fcmToken;
  String? voipToken;

  Future<void> init() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission(alert: true, badge: true, sound: true);
    fcmToken = await fcm.getToken();

    FirebaseMessaging.onMessage.listen((m) async {
      if (m.data['type'] == 'call.incoming') {
        await CallService.instance.showIncomingFromData(m.data);
      }
    });

    _voip.configure(onMessage: (payload) async {
      await CallService.instance.showIncomingFromData(
        Map<String, dynamic>.from(payload),
      );
    }, onResume: (payload) async {
      await CallService.instance.showIncomingFromData(
        Map<String, dynamic>.from(payload),
      );
    });

    voipToken = await _voip.getToken();
  }
}
