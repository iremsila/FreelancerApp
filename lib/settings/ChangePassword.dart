import 'package:WorkWise/settings/settingpage.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Change Password Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PasswordChangePage(),
    );
  }
}

class PasswordChangePage extends StatelessWidget {
  final TextEditingController _currentPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController =
  TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool isPasswordValid(String password) {
    // Şifre geçerlilik kurallarını burada kontrol edin
    // Örneğin, minimum uzunluk, büyük harf, küçük harf, sayı, vb. gereklilikleri kontrol edebilirsiniz
    // Bu yöntemi ihtiyaçlarınıza göre özelleştirin
    return password.length >= 8;
  }

  Future<void> changePassword(BuildContext context) async {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('The new passwords do not match.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Yeni şifre için geçerlilik kontrolü yap
    if (!isPasswordValid(newPassword)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('The new password is invalid.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      final settings = mysql.ConnectionSettings(
        host: '213.238.183.81',
        port: 3306,
        user: 'httpdegm_melike',
        password: 'A}c74e&QAI[x',
        db: 'httpdegm_database1',
      );

      // MySQL bağlantısını oluştur
      final conn = await mysql.MySqlConnection.connect(settings);

      // Mevcut şifreyi kontrol et
      final result = await conn.query(
          'SELECT * FROM User WHERE password = ?', [currentPassword]);

      if (result.isNotEmpty) {
        // Şifre doğru, şifreyi güncelle
        await conn.query('UPDATE User SET password = ? WHERE id = ?',
            [newPassword, result.first['id']]);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Successful'),
              content: Text('Password changed successfully.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingPageUI(),
                      ),
                    );
                  },
                  child: Text('Tamam'),
                ),
              ],
            );
          },
        );
      } else {
        // Şifre yanlış
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('The current password is incorrect.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
      }

      // Bağlantıyı kapat
      await conn.close();
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProviderData = Provider.of<ThemeProvider>(context); // Sağlayıcı sınıfının adını güncelledim
    return Scaffold(
      backgroundColor: themeProviderData.getTheme().scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Current Password',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'New Password',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'New Password (Again)',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                changePassword(context);
              },
              child: Text('Change password'),
            ),
          ],
        ),
      ),
    );
  }
}
