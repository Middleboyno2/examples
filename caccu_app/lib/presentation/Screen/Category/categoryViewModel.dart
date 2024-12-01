import 'package:caccu_app/data/usecase/categoryUsecase.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/entity/categoryEntity.dart';
import '../../../data/service/LocalStorage.dart';

class CategoryViewModel with ChangeNotifier{
  String? userId = LocalStorageService().getUserId();

  List<CategoryEntity> categories = [];

  Future<void> reload() async {
    categories = await listCategoryByUserId();
    print("Danh sách categories đã tải:");
    for (var category in categories) {
      print("ID: ${category.categoryId}, Name: ${category.name}, Icon: ${category.icon}, Limit: ${category.limit}");
    }
    notifyListeners();
  }

  Future<void> syncDefaultCategories() async{
    return await CategoryUseCase().syncDefaultCategories(userId!);
  }
  // --------------------------------------------------------------------------------------
  // test value tra ve cua list Category
  Future<void> fetchUserCategories() async {
    List<CategoryEntity> categories = await CategoryUseCase().getCategoriesByUserId(userId!);

    if (categories.isNotEmpty) {
      print("Danh sách categories của userId: $userId");
      for (var category in categories) {
        print("ID: ${category.categoryId}, Tên: ${category.name}, Icon: ${category.icon}, Limit: ${category.limit}");
      }
    } else {
      print("Không tìm thấy categories nào cho userId: $userId");
    }
  }

  //-------------------------------------------------------------------------------------------
  // tra ve list category
  Future<List<CategoryEntity>> listCategoryByUserId() async{
    return await CategoryUseCase().getCategoriesByUserId(userId!);
  }

  Future<String> getCategoryName(String categoryId) async{
    return await CategoryUseCase().getCategoryName(categoryId);
  }

  Future<List<CategoryEntity>> getCategoriesByIds(List<String> categoryIds) async{
    return await CategoryUseCase().getCategoriesByIds(categoryIds);
  }

  Future<bool> updateCate(
      String categoryId, // ID của danh mục cần cập nhật
      String name,
      String icon,
      double limit,
      ) async{
    return await CategoryUseCase().updateCate(categoryId, userId!, name, icon, limit);
  }

}