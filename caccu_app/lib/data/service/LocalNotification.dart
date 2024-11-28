import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifi{
  Future<void> requestNotificationPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted = await androidImplementation
        ?.requestNotificationsPermission();

    if (granted != null && granted) {
      print("Notification permission granted");
    } else {
      print("Notification permission denied");
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




  // Future<void> scheduleNotification() async {
  //   tz.initializeTimeZones();
  //
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     1, // Notification ID
  //     'Scheduled Notification', // Title
  //     'This is a scheduled notification.', // Body
  //     tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)), // Schedule time
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'high_importance_channel', // Channel ID
  //         'High Importance Notifications', // Channel name
  //         importance: Importance.max,
  //         priority: Priority.high,
  //       ),
  //     ),
  //
  //     // androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation:
  //     UILocalNotificationDateInterpretation.absoluteTime,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Schedule mode
  //   );
  // }


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
      final status = await Permission.scheduleExactAlarm.request();
      return status.isGranted;
    } catch (e) {
      print('Error checking exact alarm permission: $e');
      return false;
    }
  }



  Future<void> scheduleBillNotification(String billName, DateTime deadline) async {
    // Ensure timezone data is initialized
    tz.initializeTimeZones();

    // Request permission for exact alarms
    bool hasPermission = await requestExactAlarmPermission();
    if (!hasPermission) {
      print('Exact alarm permission not granted.');
      return;
    }

    // Define the notification details
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'bills_channel', // Channel ID
      'Bills Notifications', // Channel Name
      channelDescription: 'Reminders for bill deadlines', // Channel Description
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID (you can use a unique ID)
      'Hóa đơn đến hạn!', // Title
      'Hóa đơn $billName cần được thanh toán.', // Body
      tz.TZDateTime.from(deadline, tz.local), // Scheduled time
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Schedule mode
    );
  }

}