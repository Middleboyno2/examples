import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../data/entity/transactionEntity.dart';
import '../../../data/usecase/transactionUsecase.dart';


class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<List<TransactionEntity>>(
        stream: TransactionUseCase().getTransactionsByUser('/users/userId'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
          }
          // Nếu không có dữ liệu hoặc snapshot.data là null
          final transactions = snapshot.data ?? [];
          if (transactions.isEmpty) {
            return Text("No transactions available");
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(transactions[index].notes.toString()),
              );
            },
          );
        },
      )
    );
  }
}
