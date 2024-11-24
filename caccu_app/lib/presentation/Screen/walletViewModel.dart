import 'package:caccu_app/data/entity/monthlyWalletEntity.dart';
import 'package:caccu_app/data/entity/walletEntity.dart';
import 'package:caccu_app/data/usecase/walletUsecase.dart';
import 'package:caccu_app/presentation/Screen/monthlyWalletViewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalletViewModel with ChangeNotifier{

  Future<DocumentReference?> getDefaultWalletByIdUser( String userId) async{
    return await WalletUseCase().getDefaultWalletByIdUser(userId);
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