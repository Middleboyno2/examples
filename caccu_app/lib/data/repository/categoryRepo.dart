import 'package:caccu_app/data/entity/userEntity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../theme/listImage.dart';
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

  Future<bool> updateCate(
      String categoryId, // ID của danh mục cần cập nhật
      String userId,
      String name,
      String icon,
      double limit,
      ) async {
    try {
      // Chuyển đổi userId thành DocumentReference
      DocumentReference userRef = _db.collection('users').doc(userId);

      // Tạo một CategoryEntity với dữ liệu đã cập nhật
      CategoryEntity updatedCategory = CategoryEntity(
        categoryId: categoryId,
        userId: userRef,
        name: name,
        icon: icon,
        limit: limit,
      );

      // Cập nhật category trên Firestore
      await _db.collection('categories').doc(categoryId).update(updatedCategory.toMap());
      return true; // Trả về true nếu cập nhật thành công
    } catch (e) {
      print("Error updating category: $e");
      return false; // Trả về false nếu có lỗi
    }
  }


  // Xóa danh mục
  Future<void> deleteCategory(String categoryId) async {
    await _db.collection('categories').doc(categoryId).delete();
  }


  Future<void> syncDefaultCategories(String userId) async {
    // Tham chiếu đến collection "categories"
    CollectionReference categoriesRef = FirebaseFirestore.instance.collection('categories');
    DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      // Lấy tất cả các categories hiện tại của user
      QuerySnapshot snapshot = await categoriesRef.where('userId', isEqualTo: userRef).get();

      // Tạo danh sách các category name đã tồn tại
      List<String> existingNames = snapshot.docs.map((doc) {
        return (doc.data() as Map<String, dynamic>)['name']
            .toString()
            .trim()
            .toLowerCase(); // Chuẩn hóa tên (trim và toLowerCase)
      }).toList();

      // Debug: In ra các category đã tồn tại
      print("Existing categories:");
      for (var name in existingNames) {
        print(name); // In tên category
      }

      // Lặp qua defaultImages và thêm mới những mục chưa tồn tại
      for (var item in defaultImages) {
        String newName = item['name'].toString().trim().toLowerCase();
        if (!existingNames.contains(newName)) {
          await categoriesRef.add({
            'name': item['name'],
            'icon': item['path'],
            'limit': 0,
            'userId': userRef, // Sử dụng userRef
          });
          print('Thêm mới category: ${item['name']}');
        } else {
          print('Category đã tồn tại: ${item['name']}');
        }
      }
    } catch (e) {
      print('Lỗi khi đồng bộ categories: $e');
    }
  }

  // Lấy tên danh mục từ Firestore
  Future<String> getCategoryName(String categoryId) async {
    try {
      final doc = await _db.collection('categories').doc(categoryId).get();
      if (doc.exists) {
        return doc.data()?['name'] ?? 'Unknown';
      }
      return 'Unknown';
    } catch (e) {
      print('Error fetching category name: $e');
      return 'Unknown';
    }
  }

  Future<List<CategoryEntity>> getCategoriesByUserId(String userId) async {
    // Tham chiếu đến collection "categories"
    CollectionReference categoriesRef = FirebaseFirestore.instance.collection('categories');
    DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      // Lấy tất cả các categories hiện tại của user
      QuerySnapshot snapshot = await categoriesRef.where('userId', isEqualTo: userRef).get();

      // Chuyển đổi dữ liệu từ Firestore sang danh sách CategoryEntity
      List<CategoryEntity> categories = snapshot.docs.map((doc) {
        return CategoryEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return categories; // Trả về danh sách CategoryEntity
    } catch (e) {
      print('Lỗi khi lấy danh sách categories: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  // Fetch CategoryEntity list based on categoryId list
  Future<List<CategoryEntity>> getCategoriesByIds(List<String> categoryIds) async {
    if (categoryIds.isEmpty) {
      print("categoryIds list is empty. Returning an empty list.");
      return []; // Trả về danh sách trống nếu categoryIds rỗng
    }

    try {
      QuerySnapshot querySnapshot = await _db
          .collection('categories')
          .where(FieldPath.documentId, whereIn: categoryIds)
          .get();

      return querySnapshot.docs.map((doc) {
        return CategoryEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

}