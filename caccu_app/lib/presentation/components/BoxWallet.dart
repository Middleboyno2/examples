import 'package:caccu_app/data/entity/monthlyWalletEntity.dart';
import 'package:caccu_app/data/entity/walletEntity.dart';
import 'package:caccu_app/presentation/Screen/monthlyWallet/monthlyWalletViewModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletComponent extends StatelessWidget {
  final MonthlyWalletEntity? monthlyWallet;
  final VoidCallback onViewAllPressed;

  const WalletComponent({
    super.key,
    required this.monthlyWallet,
    required this.onViewAllPressed,
  });

  String formatCurrency(int value) {
    final formatter = NumberFormat("#,##0", "vi_VN"); // "vi_VN" là mã ngôn ngữ Tiếng Việt
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade600,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ví của tôi',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: onViewAllPressed,
                child: const Text(
                  'Xem tất cả',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'lib/img/wallet.png', // Thay đổi đường dẫn hình ảnh của bạn
                  height: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'default',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                '${formatCurrency(monthlyWallet!.availableBalance.toInt())} vnđ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
