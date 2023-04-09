import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper/proivder.dart';
import '../../helper/validators.dart';
import '../../shared/items/widgets.dart';
import '../../shared/resources/colors.dart';
import '../../shared/resources/fields.dart';
import '../../shared/resources/styles.dart';
import '../../utils/methods.dart';
import '../forgot_password.dart';
import '../register/signup.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {

  GlobalKey<FormState> key = GlobalKey();




  bool isSignIn = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: SizedBox(
        child: Column(
          children: [
            AppTextFields(
              hint: 'UserName',
              validator: (name) {
                return AppValidator.requiredField(name ?? '');
              },
            ),
            freev(),
            AppPassFields(
              validator: (pass) {
                return AppValidator.passFieldValidator(pass ?? '');
              },
            ),
            freev(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton( child: Text(
                  'Forget Password?',
                  style: AppStyles.links(),
                ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ForgotPasswordPage();
                        },
                      ),
                    );
                  },

                )
              ],
            ),
            freev(v: 10),
            buttons(
                text: 'Login',
                color: AppColors.primary,
                onTap: () {
                  if (key.currentState!.validate()) {
                    //go to Home page
                  }
                }),
            buttons(
                text: 'SignUp',
                color: Colors.green,
                onTap: () {
                  navigatePush(context,
                      secondPage: ChangeNotifierProvider(
                          create: (context) {
                            return AppProvider();
                          },
                          child: const SignUp()));
                }),
            freev(),
          ],
        ),
      ),
    );
  }
}