import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'core/call_service.dart';
import 'core/push_service.dart';
import 'features/call/presentation/home_page.dart';

@pragma('vm:entry-point')
Future<void> _onBackgroundFcm(RemoteMessage message) async {
  await Firebase.initializeApp();
  await CallService.instance.showIncomingFromData(message.data);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_onBackgroundFcm);
  await PushService.instance.init();
  await CallService.instance.init();
  runApp(const ProviderScope(child: VoipApp()));
}

class VoipApp extends StatelessWidget {
  const VoipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoIP CallKit POC',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomePage(),
    );
  }
}
