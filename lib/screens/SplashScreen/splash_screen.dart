import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../login/login.dart';

void main() {
  runApp(SplashScreen());
}

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 8),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      showRegisterPage: () {},
                    ))));
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery(data: MediaQueryData(), child: MaterialApp());
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            width: 300,
            child: Lottie.asset("assets/animation.json"),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "WorkWise",
            style: TextStyle(
                fontFamily: 'Monoton', fontSize: 45, color: Colors.blue),
          )
        ],
      )),
    );
  }
}
//child:
