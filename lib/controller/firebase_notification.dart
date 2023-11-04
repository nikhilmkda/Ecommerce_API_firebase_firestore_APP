import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerse_app_with_api/main.dart';

class FirebaseNotification {
  // Create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Function to initialize notification
  Future<void> initNotification() async {
    // Request permission from the user
    await _firebaseMessaging.requestPermission();

    // Fetch FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken up to here');

    // Initialize push notification handling
    await initPushNotification();
  }

  // Function to handle received messages
  void handleMesssage(RemoteMessage? message) {
    if (message == null) return;
    // Navigate to the NotificationPage when a message is received
    navigatorkey.currentState
        ?.pushNamed('/notification_screen', arguments: message);
  }

  // Function to initialize background settings
  Future<void> initPushNotification() async {
    // Handle notification when the app is terminated and opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMesssage);

    // Attach an event listener for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMesssage);
  }
}
