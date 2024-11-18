import 'package:caccu_app/data/entity/userEntity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/categoryEntity.dart';

class CategoryRepository{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm mới danh mục
  Future<void> addCategory(CategoryEntity category) async {
    await _db.collection('categories').add(category.toMap());
  }

  // Cập nhật người danh mục
  Future<void> updateCategory(String categoryId, Map<String, dynamic> updatedData) async {
    await _db.collection('categories').doc(categoryId).update(updatedData);
  }

  // Xóa danh mục
  Future<void> deleteCategory(String categoryId) async {
    await _db.collection('categories').doc(categoryId).delete();
  }
}