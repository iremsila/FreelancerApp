import 'package:flutter/material.dart';

import '../../layout/layout.dart';
import '../../shared/resources/colors.dart';
import 'login_body.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayOut(
      header: 'Login',
      dis: 'Hi, Welcome!',
      fields: Container(
          decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.all(20),
          child: LoginBody()),
    );
  }
}