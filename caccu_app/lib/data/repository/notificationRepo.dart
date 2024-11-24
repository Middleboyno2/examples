import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/notificationEntity.dart';

class NotificationRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> addNotification(
      String userId,
      String title,
      String content,
      DateTime time,
      bool status) async {
    try {
      // Convert the userId to a DocumentReference
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Create a NotificationEntity
      NotificationEntity notification = NotificationEntity(
        userId: userRef,
        title: title,
        content: content,
        time: time,
        status: status,
      );

      // Save the notification to Firestore
      await FirebaseFirestore.instance.collection('notification').add(notification.toMap());
      print('Notification added successfully');
      return true; // Return true if the addition was successful
    } catch (e) {
      print("Error adding notification: $e");
      return false; // Return false if there was an error
    }
  }

  Future<bool> checkStatusNotification(String notificationId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('notification')
          .doc(notificationId)
          .get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data['status'] ?? false; // Return the status field
      } else {
        print('Notification not found');
        return false;
      }
    } catch (e) {
      print('Error checking notification status: $e');
      return false;
    }
  }

  Future<void> setStatusNotification(String notificationId, bool newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('notification')
          .doc(notificationId)
          .update({'status': newStatus});
      print('Notification status updated successfully');
    } catch (e) {
      print('Error updating notification status: $e');
    }
  }


  Future<List<NotificationEntity>> getNotificationByUserId(
      String userId, bool status) async {
    try {
      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('notification')
          .where('userId', isEqualTo: userRef)
          .where('status', isEqualTo: status)
          .get();

      List<NotificationEntity> notifications = querySnapshot.docs.map((doc) {
        return NotificationEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return notifications;
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  Future<void> updateNotificationStatusByTime(String userId) async {
    try {
      // Get the user document reference
      DocumentReference userRef = _db.collection('users').doc(userId);

      // Calculate the time range
      DateTime currentTime = DateTime.now();
      DateTime oneDayAgo = currentTime.subtract(Duration(days: 1));

      // Query notifications for the user where time is within the last 24 hours or equal to the current time
      QuerySnapshot querySnapshot = await _db
          .collection('notification')
          .where('userId', isEqualTo: userRef)
          .where('time', isLessThanOrEqualTo: Timestamp.fromDate(currentTime))
          .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(oneDayAgo))
          .get();

      // Update the status of each notification to true
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'status': true});
      }

      print("Notification statuses updated successfully.");
    } catch (e) {
      print("Error updating notification statuses: $e");
    }
  }



}