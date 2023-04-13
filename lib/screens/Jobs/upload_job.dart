import 'package:flutter/material.dart';
import '../../Widget/bottom_nav_bar.dart';

class UploadJobNow extends StatefulWidget {
  const UploadJobNow({Key? key}) : super(key: key);

  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1),
        appBar: AppBar(
          title: const Text(
            'Upload Job',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue.shade200,
        ),
      ),
    );
  }
}
