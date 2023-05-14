import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Jobs/jobs_screen.dart';
import 'Profile/profile_screen.dart';
import 'Search/search_job.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  final screens = [
    const JobScreen(),
    SearchScreen(),
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
        Icons.search,
        size: 30,
      ),
      const Icon(
        Icons.person,
        size: 30,
      ),
    ];
    return SafeArea(
      top: false,
      child: ClipRect(
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          extendBody: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent),
              backgroundColor: Colors.white,
              title: const Padding(
                padding: EdgeInsets.only(bottom: 0, top: 0, left: 0, right: 0),
                child: Text('WorkWise',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              ),
              elevation: 2,
            ),
          ),
          body: screens[index],
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0.0, 0.75))
              ],
            ),
            child: CurvedNavigationBar(
              color: Colors.white,
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: Colors.cyan,
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
