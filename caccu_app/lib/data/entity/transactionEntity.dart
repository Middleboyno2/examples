import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionEntity {
  String? transactionId;            // ID của giao dịch
  DocumentReference walletId;           // Loại giao dịch (chi tiêu, thu nhập)
  double price;         // Số tiền giao dịch
  DocumentReference categoryId;       // Danh mục của giao dịch (ăn uống, giải trí, ...)
  DateTime? time;         // Ngày thực hiện giao dịch
  String? notes;         // Ghi chú thêm cho giao dịch
  DocumentReference userId;
  String? image;// ID của người dùng để liên kết

  TransactionEntity({
    this.transactionId,
    required this.walletId,
    required this.price,
    required this.categoryId,
    this.time,
    this.notes,
    required this.userId,
    this.image
  });

  // Chuyển đổi từ Map (dữ liệu Firebase) sang TransactionModel
  factory TransactionEntity.fromMap(Map<String, dynamic> data, String documentId) {
    return TransactionEntity(
      transactionId: documentId,
      walletId: data['walletId'],
      price: data['price']?.toDouble() ?? 0.0,
      categoryId: data['categoryId'],
      time: (data['time'] as Timestamp).toDate(),
      notes: data['note'],
      userId: data['userId'],
      image: data['image'] ?? ''
    );
  }

  // Chuyển đổi từ TransactionModel sang Map để lưu lên Firebase
  Map<String, dynamic> toMap() {
    return {
      'walletId': walletId,
      'price': price,
      'categoryId': categoryId,
      'time': time,
      'note': notes,
      'userId': userId,
      'image' : image
    };
  }
}
