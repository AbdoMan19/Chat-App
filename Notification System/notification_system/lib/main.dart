import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/authentication/presentation/screens/authentication_screen.dart';
import 'package:notification_system/home_screen.dart';

import 'Themes/dark_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('Firebase initialized');
  } catch (e) {
    log('Error initializing Firebase: $e');
  }
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification System',
      theme: darkTheme,
      initialRoute: const AuthenticationScreen().loginRouteName,
      routes: {
        const HomeScreen().routeName: (context) => const HomeScreen(),
        const AuthenticationScreen().loginRouteName: (context) =>
            const AuthenticationScreen(key: Key('sign-in')),
        const AuthenticationScreen().registerRouteName: (context) =>
            const AuthenticationScreen(key: Key('sign-up')),
      },
    );
  }
}
