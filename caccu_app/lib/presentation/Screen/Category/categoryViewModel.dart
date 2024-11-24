import 'package:caccu_app/data/usecase/categoryUsecase.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/entity/categoryEntity.dart';
import '../../../data/service/LocalStorage.dart';

class CategoryViewModel with ChangeNotifier{
  String? userId = LocalStorageService().getUserId();
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
}