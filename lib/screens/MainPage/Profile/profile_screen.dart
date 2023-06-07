import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../provider/theme_provider.dart';
import '../../../settings/settingpage.dart';
import '../../Login/login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String nameandsurname = '';
  String email = '';
  late int rating;
  List<Map<String, dynamic>> abilities = [];
  TextEditingController _abilityNameController = TextEditingController();
  TextEditingController _abilityRatingController = TextEditingController();
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

    final profileResults = await conn.query(
      'SELECT abilities, rating FROM profile WHERE user_id = ?',
      [userId],
    );

    if (profileResults.isNotEmpty) {
      setState(() {
        abilities = profileResults
            .map((row) => {
                  'name': row['abilities'],
                  'rating': row['rating'],
                })
            .toList();
      });
    }

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

    final abilitiesCheckResults = await conn.query(
      'SELECT COUNT(*) as count FROM profile WHERE user_id = ?',
      [userId],
    );

    if (abilitiesCheckResults.isNotEmpty) {
      final countRow = abilitiesCheckResults.first;
      int count = countRow['count'];

      if (count == 0) {
        await conn.query(
          'INSERT INTO profile (user_id, abilities, rating) VALUES (?, ?, ?)',
          [userId, _abilityNameController.text, rating],
        );
      } else {
        await conn.query(
          'UPDATE profile SET abilities = ?, rating = ? WHERE user_id = ?',
          [_abilityNameController.text, rating, userId],
        );
      }

      setState(() {
        abilities = [
          {'name': _abilityNameController.text, 'rating': rating}
        ];
      });
    }

    await conn.close();
  }

  Future<void> addAbility() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '213.238.183.81',
      port: 3306,
      user: 'httpdegm_melike',
      password: 'A}c74e&QAI[x',
      db: 'httpdegm_database1',
    ));

    final abilityName = _abilityNameController.text;
    final abilityRating = int.parse(_abilityRatingController.text);

    await conn.query(
      'INSERT INTO profile (user_id, abilities, rating) VALUES (?, ?, ?)',
      [userId, abilityName, abilityRating],
    );

    final updatedResults = await conn.query(
      'SELECT abilities, rating FROM profile WHERE user_id = ?',
      [userId],
    );

    if (updatedResults.isNotEmpty) {
      setState(() {
        abilities = updatedResults.map((row) {
          return {
            'name': row['abilities'],
            'rating': row['rating'],
          };
        }).toList();
        _abilityNameController.clear();
        _abilityRatingController.clear();
      });
    }

    await conn.close();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          showRegisterPage: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProviderData = Provider.of<themeProvider>(context);
    final TextStyle titleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: themeProviderData.getTheme().brightness == Brightness.light
          ? Colors.black
          : Colors.white,
    );
    final bool isLightTheme =
        themeProviderData.getTheme().brightness == Brightness.light;
    final Color appBarTextColor = isLightTheme ? Colors.black : Colors.white;
    final Color appBarBackgroundColor =
        themeProviderData.getTheme().scaffoldBackgroundColor;
    final Color backgroundColor = isLightTheme ? Colors.white : Colors.black;
    final Color foregroundColor = isLightTheme ? Colors.black : Colors.white;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: appBarBackgroundColor,
        title: Text(
          'Profile',
          style: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: appBarTextColor),
        ),
        elevation: 2,
        actions: [
          IconButton(
            onPressed: logout,
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
                    backgroundColor: Colors.black54,
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
                        'Abilities',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  _isEditing
                      ? Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: abilities.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text('${abilities[index]['name']}'),
                                  subtitle: Text(
                                      'Rating: ${abilities[index]['rating']}'),
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _abilityNameController,
                              decoration: InputDecoration(
                                labelText: 'Ability Name',
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _abilityRatingController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Ability Rating (1-10)',
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  rating =
                                      int.parse(_abilityRatingController.text);
                                });
                                updateAbilities();
                              },
                              child: Text('Update Abilities'),
                            ),
                            SizedBox(height: 8),
                          ],
                        )
                      : Column(
                          children: abilities
                              .map(
                                (ability) => ListTile(
                                  title: Text(ability['name']),
                                  subtitle:
                                      Text('Rating: ${ability['rating']}'),
                                ),
                              )
                              .toList(),
                        ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    child:
                        Text(_isEditing ? 'Cancel Editing' : 'Edit Abilities'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Add New Ability'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _abilityNameController,
                                decoration: InputDecoration(
                                  labelText: 'Ability Name',
                                ),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _abilityRatingController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Ability Rating (1-10)',
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                addAbility();
                                Navigator.pop(context);
                              },
                              child: Text('Add'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Add New Ability'),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingPageUI(),
                        ),
                      );
                    },
                    child: Text('Go to Settings'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
