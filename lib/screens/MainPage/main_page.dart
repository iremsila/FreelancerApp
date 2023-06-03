import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Jobs/jobs_screen.dart';
import 'Jobs/posted_job.dart';
import 'Notification/notification_screen.dart';
import 'Profile/profile_screen.dart';
import 'Search/search_job.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  int notificationCount = 0;

  final screens = [
    JobScreen(),
    JobListScreen(),
    SearchScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<MySqlConnection> getConnection() async {
    final settings = new ConnectionSettings(
      host: '213.238.183.81',
      port: 3306,
      user: 'httpdegm_hudai',
      password: ',sPE[gd^hbl1',
      db: 'httpdegm_database1',
    );
    return await MySqlConnection.connect(settings);
  }

  Future<void> fetchNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    var conn = await getConnection();
    var results = await conn.query(
      'SELECT id FROM notifications WHERE employer_id = ? AND is_read = 0',
      [userId],
    );
    await conn.close();

    int count = results.length;

    setState(() {
      notificationCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchNotificationCount(); // Bildirim sayısını güncellemek için çağrı yapılıyor

    final items = <Widget>[
      const Icon(
        Icons.home,
        size: 30,
      ),
      const Icon(
        Icons.document_scanner,
        size: 30,
      ),
      const Icon(
        Icons.search,
        size: 30,
      ),
      Stack(
        children: [
          const Icon(
            Icons.notifications,
            size: 30,
          ),
          if (notificationCount > 0)
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  notificationCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
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
