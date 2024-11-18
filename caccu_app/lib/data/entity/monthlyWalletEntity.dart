// lib/data/models/monthly_wallet_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyWalletEntity {
  String? monthlyWalletId;
  String walletId;
  double availableBalance;
  double currently;
  DateTime month;

  MonthlyWalletEntity({
    this.monthlyWalletId,
    required this.walletId,
    required this.availableBalance,
    required this.currently,
    required this.month,
  });

  // Chuyển đổi từ Map (Firestore) sang MonthlyWallet
  factory MonthlyWalletEntity.fromMap(Map<String, dynamic> data, String documentId) {
    return MonthlyWalletEntity(
      monthlyWalletId: documentId,
      walletId: data['walletId'] ?? '',
      availableBalance: data['availableBalance']?.toDouble() ?? 0.0,
      currently: data['currently']?.toDouble() ?? 0.0,
      month: (data['month'] as Timestamp).toDate(),
    );
  }

  // Chuyển đổi từ MonthlyWallet sang Map để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'walletId': walletId,
      'availableBalance': availableBalance,
      'currently': currently,
      'month': month,
    };
  }
}
