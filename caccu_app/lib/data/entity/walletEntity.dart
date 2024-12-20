// lib/data/models/wallet_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class WalletEntity {
  String? walletId;
  DocumentReference userId;
  String walletName;

  WalletEntity({
    this.walletId,
    required this.userId,
    required this.walletName,
  });

  // Chuyển đổi từ Map (Firestore) sang Wallet
  factory WalletEntity.fromMap(Map<String, dynamic> data, String documentId) {
    return WalletEntity(
      walletId: documentId,
      userId: data['userId'] ?? '',
      walletName: data['walletName'] ?? '',
    );
  }

  // Chuyển đổi từ Wallet sang Map để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'walletName': walletName,
    };
  }
}
