import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../screens/Jobs/jobs_screen.dart';
import '../screens/Jobs/upload_job.dart';
import '../screens/Profile/profile_screen.dart';

class BottomNavigationBarForApp extends StatelessWidget {
  int indexNum = 0;

  BottomNavigationBarForApp({super.key, required this.indexNum});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.blue.shade200,
      backgroundColor: Colors.white,
      buttonBackgroundColor: Colors.blue.shade100,
      height: 50,
      index: indexNum,
      items: const [
        Icon(
          Icons.home_outlined,
          size: 30,
          color: Colors.black87,
        ),
        Icon(
          Icons.add,
          size: 30,
          color: Colors.black87,
        ),
        Icon(
          Icons.person_outlined,
          size: 30,
          color: Colors.black87,
        ),
      ],
      animationDuration: const Duration(
        milliseconds: 1000,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const JobScreen()));
        } else if (index == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const UploadJobNow()));
        } else if (index == 2) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()));
        }
      },
    );
  }
}
