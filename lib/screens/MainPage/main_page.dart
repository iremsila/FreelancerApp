import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/theme_provider.dart'; // Doğru tema sağlayıcı dosyasını içe aktar
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
    fetchNotificationCount(); // Bildirim sayısını güncellemek için çağrı yapılıyor
  }

  Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
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
      'SELECT id FROM notifications WHERE receiver_id = ? AND is_read = 0',
      [userId],
    );
    await conn.close();

    int count = results.length;

    setState(() {
      notificationCount = count;
    });
  }

  Future<void> markNotificationsAsRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    var conn = await getConnection();
    await conn.query(
      'UPDATE notifications SET is_read = 1 WHERE receiver_id = ?',
      [userId],
    );
    await conn.close();

    setState(() {
      notificationCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProviderData = Provider.of<ThemeProvider>(context); // Sağlayıcı sınıfının adını güncelledim
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
          backgroundColor: themeProviderData.getTheme().scaffoldBackgroundColor,
          extendBody: true,
          body: GestureDetector(
            onTap: () {
              // Bildirime tıklandığında burası çalışacak
              if (notificationCount > 0) {
                markNotificationsAsRead();
                // Burada bildirimleri okundu olarak işaretlemek veya sayıyı sıfırlamak için işlemler yapabilirsiniz
              }
            },
            child: screens[index],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: const Offset(0.0, 0.75),
                ),
              ],
            ),
            child: Consumer<ThemeProvider>(
              builder: (context, themeProviderData, _) => BottomNavigationBar(
                backgroundColor: themeProviderData.getTheme().scaffoldBackgroundColor,
                selectedItemColor: themeProviderData.getTheme().textTheme.bodyText1?.color,
                unselectedItemColor: themeProviderData.getTheme().textTheme.bodyText2?.color,
                currentIndex: index,
                items: items.map((Widget item) {
                  return BottomNavigationBarItem(
                    icon: item,
                    label: '',
                  );
                }).toList(),
                onTap: (int tappedIndex) {
                  setState(() {
                    index = tappedIndex;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
