import 'package:WorkWise/settings/settingpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../provider/theme_provider.dart';
import '../../Login/login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String nameandsurname = '';
  String email = '';
  String abilities = '';

  TextEditingController _abilitiesController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }

  Future<void> fetchDataFromDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '213.238.183.81',
      port: 3306,
      user: 'httpdegm_melike',
      password: 'A}c74e&QAI[x',
      db: 'httpdegm_database1',
    ));

    // Kullanıcının profil bilgilerini sorgulayın
    final userResults = await conn.query(
      'SELECT nameandsurname, email FROM User WHERE id = ?',
      [userId],
    );

    if (userResults.isNotEmpty) {
      final userRow = userResults.first;
      setState(() {
        nameandsurname = userRow['nameandsurname'];
        email = userRow['email'];
      });
    }

    // Kullanıcının abilities bilgisini sorgulayın
    final profileResults = await conn.query(
      'SELECT abilities FROM profile WHERE user_id = ?',
      [userId],
    );

    if (profileResults.isNotEmpty) {
      final profileRow = profileResults.first;
      setState(() {
        var abilitiesBlob = profileRow['abilities'];
        abilities = abilitiesBlob.toString(); // Blob veriyi String'e dönüştür
        _abilitiesController.text = abilities;
      });
    }

    // Veritabanı bağlantısını kapatın
    await conn.close();
  }

  Future<void> updateAbilities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '213.238.183.81',
      port: 3306,
      user: 'httpdegm_melike',
      password: 'A}c74e&QAI[x',
      db: 'httpdegm_database1',
    ));

    // Öncelikle, kullanıcının abilities bilgisinin mevcut olup olmadığını kontrol edin
    final abilitiesCheckResults = await conn.query(
      'SELECT COUNT(*) as count FROM profile WHERE user_id = ?',
      [userId],
    );

    if (abilitiesCheckResults.isNotEmpty) {
      final countRow = abilitiesCheckResults.first;
      int count = countRow['count'];

      if (count == 0) {
        // Kayıt bulunmadığı için INSERT işlemi yapın
        await conn.query(
          'INSERT INTO profile (user_id, abilities) VALUES (?, ?)',
          [userId, _abilitiesController.text],
        );
      } else {
        // Kayıt bulunduğu için UPDATE işlemi yapın
        await conn.query(
          'UPDATE profile SET abilities = ? WHERE user_id = ?',
          [_abilitiesController.text, userId],
        );
      }

      setState(() {
        abilities = _abilitiesController.text;
      });
    }

    await conn.close();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId'); // Kullanıcıyı çıkış yapmış olarak işaretle

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          showRegisterPage: () {},
        ),
      ),
    );
    // LoginPage'a yönlendir
  }

  @override
  Widget build(BuildContext context) {
    final themeProviderData = Provider.of<themeProvider>(context);
    final TextStyle titleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: themeProviderData.getTheme().brightness == Brightness.light ? Colors.black : Colors.white,
    );
    final bool isLightTheme = themeProviderData.getTheme().brightness == Brightness.light;
    final Color appBarTextColor = isLightTheme ? Colors.black : Colors.white;
    final Color appBarBackgroundColor = themeProviderData.getTheme().scaffoldBackgroundColor;
    final Color backgroundColor = isLightTheme ? Colors.white : Colors.black;
    final Color foregroundColor = isLightTheme ? Colors.black : Colors.white;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: appBarBackgroundColor,
        title: Text(
          'Profile',
          style: GoogleFonts.openSans(fontSize: 25, fontWeight: FontWeight.bold, color: appBarTextColor),
        ),
        elevation: 2,
        actions: [
          IconButton(
            onPressed: logout, // logout metodunu onPressed olayına bağla
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.black54,
                    child: Text(
                      nameandsurname.isNotEmpty ? nameandsurname[0].toUpperCase() : '',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '$nameandsurname',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 8),
                  Text(
                    email,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Abilities',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  _isEditing
                      ? TextFormField(
                    controller: _abilitiesController,
                    decoration: InputDecoration(
                      labelText: 'Enter your abilities',
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  )
                      : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      abilities,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingPageUI()),
                          );
                        },
                        child: Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: TextButton(
              onPressed: () async {
                if (_isEditing) {
                  await updateAbilities();
                }
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
              child: Text(
                _isEditing ? 'Save' : 'Edit',
                style: titleStyle,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
    );
  }
}
