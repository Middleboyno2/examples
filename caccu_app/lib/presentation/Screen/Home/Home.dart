import 'package:caccu_app/presentation/components/spendingChart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/box.dart';
import '../../components/button.dart';
import '../UserViewModel.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 600,
                  child: SpendingChart()
              ),
            ],
          );
        },
      ),
    );
  }
}
