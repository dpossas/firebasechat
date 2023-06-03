import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/utils/env.dart';
import 'views/chat/chat_page.dart';
import 'views/chat/room_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: Env.firebaseApiKey,
      appId: Env.firebaseAppId,
      messagingSenderId: Env.firebaseMessagingSenderId,
      projectId: Env.firebaseProjectId,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My.chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => RoomPage(),
        '/chat': (context) => const ChatPage(),
      },
    );
  }
}
