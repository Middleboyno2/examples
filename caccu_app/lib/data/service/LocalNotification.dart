import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifi{
  // Future<void> requestNotificationPermission() async {
  //   //   final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
  //   //   flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
  //   //       AndroidFlutterLocalNotificationsPlugin>();
  //   //
  //   //   final bool? granted = await androidImplementation
  //   //       ?.requestNotificationsPermission();
  //   //
  //   //   if (granted != null && granted) {
  //   //     print("Notification permission granted");
  //   //   } else {
  //   //     print("Notification permission denied");
  //   //   }
  //   // }


  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }


  Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'high_importance_channel', // Channel ID
      'High Importance Notifications', // Channel name
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Test Notification', // Title
      'This is the body of the notification.', // Body
      notificationDetails,
    );
  }



  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // ID
      'High Importance Notifications', // Name
      description: 'This channel is used for important notifications.', // Description
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }



  Future<bool> requestExactAlarmPermission() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 33) { // Check for Android 13+
        final status = await Permission.scheduleExactAlarm.request();
        return status.isGranted;
      }
      return true; // Permissions not required for Android < 13
    } catch (e) {
      print('Error checking exact alarm permission: $e');
      return false;
    }
  }



  Future<void> scheduleBillNotification(String billName, DateTime deadline) async {
    tz.initializeTimeZones();
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 33) { // Only request for Android 13+
      bool hasPermission = await requestExactAlarmPermission();
      if (!hasPermission) {
        print('Exact alarm permission not granted.');
        return;
      }
    }

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'bills_channel',
      'Bills Notifications',
      channelDescription: 'Reminders for bill deadlines',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Hóa đơn đến hạn!',
      'Hóa đơn $billName cần được thanh toán$deadline.',
      tz.TZDateTime.from(deadline, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

}