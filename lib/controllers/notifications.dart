import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationServices {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() async {
    const InitializationSettings initializationSettingsAndroid =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    flutterLocalNotificationsPlugin.initialize(initializationSettingsAndroid);

    await _requestNotificationPermission();
  }

  static void showNotification(
      {required int notificationId, title, body, required DateTime dateTime}) async {
    var scheduledDate = dateTime.subtract(Duration(minutes: 10));
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.max,
      priority: Priority.max,
      autoCancel: true,
      playSound: true,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(notificationId, title, body,
        tz.TZDateTime.from(scheduledDate, tz.local), notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  static Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      print("permission granted");
    } else if (status.isDenied) {
      print("permission denied");
    } else if (status.isPermanentlyDenied) {
      print("permission permanently denied");
    }
  }
}
