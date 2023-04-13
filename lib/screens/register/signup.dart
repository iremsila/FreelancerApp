import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../layout/layout.dart';
import '../../shared/resources/colors.dart';
import '../../utils/methods.dart';
import 'signup_body.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayOut(
      leading: IconButton(
          onPressed: () {
            navigatePop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primary,
            size: 20,
          )),
      header: 'SignUp',
      dis:'',
      fields: const SignUpBody(),
    );
  }
}