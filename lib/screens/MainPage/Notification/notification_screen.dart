import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../provider/theme_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  String userRole = '';

  @override
  void initState() {
    super.initState();
    fetchUserRole().then((role) {
      setState(() {
        userRole = role;
        fetchNotifications();
      });
    });
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

  Future<String> fetchUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    var conn = await getConnection();
    var results = await conn.query(
      'SELECT freelanceroremployer FROM User WHERE id = ?',
      [userId],
    );
    await conn.close();
    if (results.isNotEmpty) {
      var row = results.first;
      return row['freelanceroremployer'];
    } else {
      return '';
    }
  }

  Future<void> fetchNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    var conn = await getConnection();
    var results = await conn.query(
      'SELECT notifications.id, notifications.message, notifications.is_read, upload_job1.job_title FROM notifications JOIN upload_job1 ON upload_job1.id = notifications.job_id WHERE notifications.receiver_id = ?',
      [userId],
    );
    await conn.close();

    final newNotifications = results.map((row) {
      final message = row['message'] as String;
      final notificationId = row['id'] as int;
      final isRead = row['is_read'] as int == 1;

      return {
        'id': notificationId,
        'message': message,
        'isRead': isRead,
      };
    }).toList();

    setState(() {
      notifications = newNotifications;
    });
  }

  Future<void> deleteNotification(int notificationId) async {
    var conn = await getConnection();
    await conn.query(
      'DELETE FROM notifications WHERE id = ?',
      [notificationId],
    );
    await conn.close();

    setState(() {
      notifications
          .removeWhere((notification) => notification['id'] == notificationId);
    });
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    var conn = await getConnection();
    await conn.query(
      'UPDATE notifications SET is_read = 1 WHERE id = ?',
      [notificationId],
    );
    await conn.close();

    setState(() {
      notifications = notifications.map((notification) {
        if (notification['id'] == notificationId) {
          return {
            ...notification,
            'isRead': true,
          };
        }
        return notification;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProviderData = Provider.of<themeProvider>(context);
    final bool isLightTheme = themeProviderData.getTheme().brightness == Brightness.light;
    final Color appBarTextColor = isLightTheme ? Colors.black : Colors.white;
    final Color appBarBackgroundColor = themeProviderData.getTheme().scaffoldBackgroundColor;
    return Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: appBarBackgroundColor,
        title: Text(
          'Notification',
          style: GoogleFonts.openSans(fontSize: 25, fontWeight: FontWeight.bold, color: appBarTextColor),
        ),
        elevation: 2,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final bool isRead = notification['isRead'];

          return Dismissible(
            key: Key(notification['id'].toString()),
            direction: DismissDirection.horizontal,
            background: Container(
              color: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: AlignmentDirectional.centerStart,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: AlignmentDirectional.centerEnd,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              deleteNotification(notification['id']);
            },
            child: ListTile(
              title: Text(notification['message']),
              tileColor: isRead ? Colors.grey.shade400 : Colors.greenAccent.shade200,
              onTap: isRead ? null : () {
                markNotificationAsRead(notification['id']);
              },
            ),
          );
        },
      ),
    );
  }
}