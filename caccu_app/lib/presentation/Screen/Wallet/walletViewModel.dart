import 'package:caccu_app/data/entity/monthlyWalletEntity.dart';
import 'package:caccu_app/data/entity/walletEntity.dart';
import 'package:caccu_app/data/service/LocalStorage.dart';
import 'package:caccu_app/data/usecase/walletUsecase.dart';
import 'package:caccu_app/presentation/Screen/monthlyWallet/monthlyWalletViewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalletViewModel with ChangeNotifier{
  // String? userIdString = LocalStorageService().getUserId();

  Future<bool> createDefaultWallet(String userId) async{
    return await WalletUseCase().createDefaultWallet(userId);
  }
  Future<bool> checkDefaultWalletExists(String userId) async{
    return await WalletUseCase().checkDefaultWalletExists(userId);
  }

  Future<DocumentReference?> getDefaultWalletByIdUser( String userId) async{
    // Kiểm tra nếu ví mặc định không tồn tại
    if (!(await checkDefaultWalletExists(userId))) {
      // Tạo ví mặc định nếu không tồn tại
      bool created = await createDefaultWallet(userId);
      if (!created) {
        throw Exception("Failed to create default wallet");
      }
    }
    // Lấy ví mặc định
    return WalletUseCase().getDefaultWalletByIdUser(userId);
  }

  Future<List<WalletEntity>> fetchWalletsByUserId(String userId) async {
    return await WalletUseCase().getListWalletByUserId(userId);
  }

  Future<List<DocumentReference<Object?>?>> getListWalletRefsByUserId(String userId) async {
    return await WalletUseCase().getListWalletRefsByUserId(userId);
  }

  Future<bool> deleteWallet(String walletId){
    return WalletUseCase().deleteWallet(walletId);
  }

  Future<bool> saveWallet(String userId, String walletName) async{
    DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final monthlyWallet = WalletEntity(userId: userRef, walletName: walletName);
    bool a = await WalletUseCase().addWallet(monthlyWallet);
    if (a){
      return true;
    }
    return false;
  }

  Future<String> getWalletName( String walletId) async{
    return await WalletUseCase().getWalletName(walletId);
  }




}