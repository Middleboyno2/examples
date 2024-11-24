// lib/data/models/bill_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class BillEntity {
  String? billId;
  DocumentReference userId;
  DocumentReference categoryId;
  String name;
  double price;
  DateTime deadline;
  bool repeat;

  BillEntity({
    this.billId,
    required this.userId,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.deadline,
    required this.repeat
  });

  // Chuyển đổi từ Map (Firestore) sang Bill
  factory BillEntity.fromMap(Map<String, dynamic> data, String documentId) {
    return BillEntity(
      billId: documentId,
      userId: data['userId'] ?? '',
      categoryId: data['categoryId'] ?? '',
      name: data['name'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      deadline: (data['deadline'] as Timestamp).toDate(),
      repeat: data['repeat'] ?? ''
    );
  }

  // Chuyển đổi từ Bill sang Map để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'categoryId': categoryId,
      'name': name,
      'price': price,
      'deadline': deadline,
      'repeat': repeat
    };
  }
}
