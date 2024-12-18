import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chato/authentication/presentation/screens/authentication_screen.dart';

import 'Themes/dark_theme.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _firebaseMessaging = FirebaseMessaging.instance;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print(message.notification!.title);
  print(message.notification!.body);
}

void showNotification(
    {required BuildContext context,
    required String title,
    required String body}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"))
      ],
    ),
  );
}

final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'channel_id', // Channel ID
    'channel_name', // Channel name
    channelDescription: 'channel_description', // Channel description
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await _localNotificationsPlugin.show(
    message.notification.hashCode, // Unique ID
    message.notification?.title, // Notification title
    message.notification?.body, // Notification body
    notificationDetails,
  );
}

Future<void> initNotification() async {
  // Request notification permissions (for iOS)
  await _firebaseMessaging.requestPermission();

  // Get the device FCM token
  final fcmToken = await _firebaseMessaging.getToken();
  print("Token: $fcmToken");

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  // Initialize local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await _localNotificationsPlugin.initialize(initializationSettings);

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Foreground message received: ${message.notification?.title}');

    if (message.notification != null) {
      showLocalNotification(message);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await initNotification();
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
        const AuthenticationScreen().loginRouteName: (context) =>
            const AuthenticationScreen(key: Key('sign-in')),
        const AuthenticationScreen().registerRouteName: (context) =>
            const AuthenticationScreen(key: Key('sign-up')),
      },
    );
  }
}
