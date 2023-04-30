import 'package:FreelancerApp/screens/login/login_body.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
        return  MaterialApp(
          title: 'Flutter Demo',
          home: LoginPage(showRegisterPage: () {  },),
        );
  }
}