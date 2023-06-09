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
  double rating = 5.0;
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

    await conn.query(
      'INSERT INTO profile (user_id, abilities, rating) VALUES (?, ?, ?)',
      [userId, _abilityNameController.text, rating],
    );

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

  Future<void> deleteAbility(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '213.238.183.81',
      port: 3306,
      user: 'httpdegm_melike',
      password: 'A}c74e&QAI[x',
      db: 'httpdegm_database1',
    ));

    final abilityName = abilities[index]['name'];

    await conn.query(
      'DELETE FROM profile WHERE user_id = ? AND abilities = ?',
      [userId, abilityName],
    );

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

  @override
  Widget build(BuildContext context) {
    final themeProviderData = Provider.of<ThemeProvider>(context);
    final bool isLightTheme =
        themeProviderData.getTheme().brightness == Brightness.light;
    final Color appBarTextColor = isLightTheme ? Colors.black : Colors.white;
    final Color appBarBackgroundColor =
        themeProviderData.getTheme().scaffoldBackgroundColor;
    final Color TextColor2 = isLightTheme ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: appBarBackgroundColor,
        title: Text(
          'Profile',
          style: GoogleFonts.openSans(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: appBarTextColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: TextColor2),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPageUI()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: TextColor2),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Confirmation'),
                    content: Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text('Log Out'),
                        onPressed: () {
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.clear().then((value) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => LoginPage(
                                    showRegisterPage: () {},
                                  ),
                                ),
                                ModalRoute.withName('/'),
                              );
                            });
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black54,
            child: Text(
              nameandsurname.isNotEmpty ? nameandsurname[0].toUpperCase() : '',
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          Text(
            nameandsurname,
            style: GoogleFonts.openSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            email,
            style: GoogleFonts.openSans(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Abilities',
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.8,
                  ),
                  itemCount: abilities.length + 1,
                  itemBuilder: (context, index) {
                    if (index == abilities.length) {
                      return _buildAddAbilityCard();
                    } else {
                      final ability = abilities[index];
                      return _buildAbilityCard(ability, index);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbilityCard(Map<String, dynamic> ability, int index) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ability['name'],
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Rating: ${ability['rating']}',
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteAbility(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddAbilityCard() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Add Ability'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _abilityNameController,
                    decoration: InputDecoration(
                      labelText: 'Ability Name',
                    ),
                  ),
                  SizedBox(height: 16),
                  Slider(
                    value: rating.toDouble(), // Convert 'rating' to 'double'
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: (double value) {
                      setState(() {
                        rating = value; // Convert 'value' to 'int'
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Add'),
                    onPressed: () {
                      addAbility();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          size: 48,
        ),
      ),
    );
  }
}
