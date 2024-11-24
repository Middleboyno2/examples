// lib/data/models/monthly_wallet_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyWalletEntity {
  String? monthlyWalletId;
  DocumentReference walletId;
  double availableBalance;
  String currency;
  int month;

  MonthlyWalletEntity({
    this.monthlyWalletId,
    required this.walletId,
    required this.availableBalance,
    required this.currency,
    required this.month,
  });

  // Chuyển đổi từ Map (Firestore) sang MonthlyWallet
  factory MonthlyWalletEntity.fromMap(Map<String, dynamic> data, String documentId) {
    return MonthlyWalletEntity(
      monthlyWalletId: documentId,
      walletId: data['walletId'] ?? '',
      availableBalance: data['availableBalance']?.toDouble() ?? 0.0,
      currency: data['currency'],
      month: data['month'],
    );
  }

  // Chuyển đổi từ MonthlyWallet sang Map để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'walletId': walletId,
      'availableBalance': availableBalance,
      'currency': currency,
      'month': month,
    };
  }
}
