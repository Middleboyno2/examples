import 'package:caccu_app/presentation/Screen/Account/Login.dart';
import 'package:caccu_app/presentation/Screen/Account/UserViewModel.dart';
import 'package:flutter/material.dart';

import '../../components/box.dart';
import '../../components/button.dart';

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: MyBox(
          child: MyButton(
            onTap: () {
              UserViewModel().logOut(context);

            },
          ),
        ),
      ),
    );
  }
}
