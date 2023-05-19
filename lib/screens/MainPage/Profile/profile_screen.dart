import 'package:WorkWise/settings/settingpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Login/login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String nameandsurname = '';
  String email = '';
  String description = '';

  TextEditingController _descriptionController = TextEditingController();

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
    final results = await conn.query(
      'SELECT nameandsurname, email FROM User WHERE id = ?',
      [userId],
    );

    final resultD = await conn.query(
      'SELECT about_me FROM profile WHERE id= ?',
      [userId],
    );

    if (results.isNotEmpty) {
      final row = results.first;
      setState(() {
        nameandsurname = row['nameandsurname'];
        email = row['email'];

        _descriptionController.text = description;
      });
    }

    // Veritabanı bağlantısını kapatın
    await conn.close();
  }

  Future<void> updateDescription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '213.238.183.81',
      port: 3306,
      user: 'httpdegm_melike',
      password: 'A}c74e&QAI[x',
      db: 'httpdegm_database1',
    ));

    await conn.query(
      'UPDATE profile SET about_me = ? WHERE id = ?',
      [_descriptionController.text, userId],
    );

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
              )),
    );
    // LoginPage'a yönlendir
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style:
              GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),
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
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue,
                    child: Text(
                      nameandsurname.isNotEmpty
                          ? nameandsurname[0].toUpperCase()
                          : '',
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
                        'About Me',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 50),
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
                  _isEditing
                      ? TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'About you',
                          ),
                          onChanged: (value) {
                            setState(() {
                              description = value;
                            });
                          },
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            description,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: TextButton(
              onPressed: () {
                setState(() {
                  if (_isEditing) {
                    updateDescription();
                  }
                  _isEditing = !_isEditing;
                });
              },
              child: Text(_isEditing ? 'Save' : 'Edit'),
            ),
          ),
        ],
      ),
    );
  }
}
