import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'Jobs/jobs_screen.dart';
import 'Jobs/upload_job.dart';
import 'Profile/profile_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  final screens = [
    const JobScreen(),
    UploadJobNow(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(
        Icons.home,
        size: 30,
      ),
      const Icon(
        Icons.add,
        size: 30,
      ),
      const Icon(
        Icons.person,
        size: 30,
      ),
    ];
    return Container(
      color: Colors.blue.shade200,
      child: SafeArea(
        top: false,
        child: ClipRect(
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.blue.shade200,
              title: const Text('WorkWise',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              elevation: 0,
              centerTitle: true,
            ),
            body: screens[index],
            bottomNavigationBar: CurvedNavigationBar(
              color: Colors.blue.shade200,
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: Colors.purple.shade200,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              height: 60,
              index: index,
              items: items,
              onTap: (index) => setState(() => this.index = index),
            ),
          ),
        ),
      ),
    );
  }
}
