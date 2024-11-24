import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationEntity {
  String? notificationId; // ID của thông báo
  String content;         // Nội dung thông báo
  bool status;            // Trạng thái thông báo (true/false)
  DateTime? time;         // Thời gian thông báo
  String title;           // Tiêu đề thông báo
  DocumentReference userId; // ID của người dùng liên kết

  NotificationEntity({
    this.notificationId,
    required this.content,
    required this.status,
    this.time,
    required this.title,
    required this.userId,
  });

  // Chuyển đổi từ Map (Firestore) sang NotificationEntity
  factory NotificationEntity.fromMap(Map<String, dynamic> data, String documentId) {
    return NotificationEntity(
      notificationId: documentId,
      content: data['conten'] ?? '',
      status: data['status'] ?? false,
      time: (data['time'] as Timestamp).toDate(),
      title: data['title'] ?? '',
      userId: data['userId'],
    );
  }

  // Chuyển đổi từ NotificationEntity sang Map để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'conten': content,
      'status': status,
      'time': time,
      'title': title,
      'userId': userId,
    };
  }
}