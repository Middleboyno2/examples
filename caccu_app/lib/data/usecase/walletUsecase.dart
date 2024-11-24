
import 'package:caccu_app/data/repository/walletRepo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/walletEntity.dart';

class WalletUseCase {
  final WalletRepository _walletRepository = WalletRepository();
  Future<String> getWalletName(String walletId){
    return _walletRepository.getWalletName(walletId);
  }
  Future<bool> addWallet(WalletEntity wallet){
    return _walletRepository.addWallet(wallet);
  }

  Future<bool> deleteWallet(String walletId){
    return _walletRepository.deleteWallet(walletId);
  }

  // lấy danh sách tất cả wallet theo user
  Future<List<WalletEntity>> getListWalletByUserId(String userId){
    return _walletRepository.getListWalletByUserId(userId);
  }
  Future<List<DocumentReference?>> getListWalletRefsByUserId(String userId){
    return _walletRepository.getListWalletRefsByUserId(userId);
  }

  // lay wallet default
  Future<DocumentReference?> getDefaultWalletByIdUser(String userId) async{
    return _walletRepository.getDefaultWalletByIdByUser(userId);
  }

  Future<bool> createDefaultWallet(String userId){
    return _walletRepository.createDefaultWallet(userId);
  }

  Future<bool> checkDefaultWalletExists(String userId){
    return _walletRepository.checkDefaultWalletExists(userId);
  }

}