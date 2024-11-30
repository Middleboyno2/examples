import 'package:caccu_app/data/repository/categoryRepo.dart';

import '../entity/categoryEntity.dart';

class CategoryUseCase{
  final CategoryRepository _categoryRepository = CategoryRepository();

  Future<void> syncDefaultCategories(String userId){
    return _categoryRepository.syncDefaultCategories(userId);
  }
  Future<List<CategoryEntity>> getCategoriesByUserId(String userId){
    return _categoryRepository.getCategoriesByUserId(userId);
  }

  Future<String> getCategoryName(String categoryId){
    return _categoryRepository.getCategoryName(categoryId);
  }


  Future<List<CategoryEntity>> getCategoriesByIds(List<String> categoryIds){
    return _categoryRepository.getCategoriesByIds(categoryIds);
  }
}