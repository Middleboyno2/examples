// lib/data/models/category_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryEntity {
  String? categoryId;
  DocumentReference userId;
  String name;
  String icon;
  double limit;

  CategoryEntity({
    this.categoryId,
    required this.userId,
    required this.name,
    required this.icon,
    required this.limit,
  });

  // Chuyển đổi từ Map (Firestore) sang Category
  factory CategoryEntity.fromMap(Map<String, dynamic> data, String documentId) {
    return CategoryEntity(
      categoryId: documentId,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      icon: data['icon'] ?? '',
      limit: data['limit']?.toDouble() ?? 0.0,
    );
  }

  // Chuyển đổi từ Category sang Map để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'icon': icon,
      'limit': limit,
    };
  }
}
