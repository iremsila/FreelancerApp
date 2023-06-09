import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/theme_provider.dart';
import '../screens/Login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ChangePassword.dart';


void settingpage() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class irem extends StatefulWidget {
  const irem({Key? key}) : super(key: key);

  @override
  State<irem> createState() => _iremState();
}

class _iremState extends State<irem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Enter your e-mail and we'll send you a password reset link to your email. ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ThemeProvider(ThemeData.dark())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SettingPageUI(),
      ),
    );
  }
}

class SettingPageUI extends StatefulWidget {
  @override
  _SettingPageUIState createState() => _SettingPageUIState();
}

class _SettingPageUIState extends State<SettingPageUI> {
  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print("$command bulunamadı");
    }
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

  Future<void> deleteUser(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    var conn = await getConnection();
    await conn.query(
      'DELETE FROM User WHERE id = ?',
      [userId],
    );
    await conn.close();

    await prefs.remove('userId');
  }

  bool valNotify1 = true;
  bool valNotify2 = false;
  bool valNotify3 = false;
  bool _iconBool = false;

  IconData _iconLight = Icons.wb_sunny;

  IconData _iconDark = Icons.nights_stay;
  ThemeData _lightTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.light,
  );

  ThemeData _darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
  );

  onChangeFunction(bool newValue1) {
    setState(() {
      valNotify1 = newValue1;
    });
  }

  onChangeFunction2(bool newValue2) {
    setState(() {
      valNotify2 = newValue2;
    });
  }

  onChangeFunction3(bool newValue3) {
    setState(() {
      valNotify3 = newValue3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final TextStyle titleStyle = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: theme.getTheme().brightness == Brightness.light ? Colors.black : Colors.white,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.getTheme(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Settings", style: TextStyle(fontSize: 22)),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: Text('Profile',style: TextStyle(
                  fontWeight: FontWeight.w500,fontSize:17
              )),
              tiles: [
                SettingsTile(
                  title: Text('Change Password', style: titleStyle),
                  leading: Icon(Icons.lock),
                  onPressed: (BuildContext context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PasswordChangePage();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text('Suggestions and Opinions',style: TextStyle(
                  fontWeight: FontWeight.w500,fontSize:17
              )),
              tiles: [
                SettingsTile(
                  title: Text('E-mail', style: titleStyle),
                  leading: Icon(Icons.mail),
                  onPressed: (BuildContext context) {
                    customLaunch("mailto:helloworld@gmail.com");
                  },
                ),
                SettingsTile(
                  title: Text('Telephone', style: titleStyle),
                  leading: Icon(Icons.phone),
                  onPressed: (BuildContext context) {
                    customLaunch("tel:0123456789");
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text('Theme',style: TextStyle(
                  fontWeight: FontWeight.w500,fontSize:17
              )),
              tiles: [
                SettingsTile(
                  title: Text('Dark Mode', style: titleStyle),
                  leading: Row(
                    children: [
                      Icon(
                        Icons.nights_stay_outlined,
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  trailing: Switch(
                    value: theme.getTheme().brightness == Brightness.dark,
                    onChanged: (bool value) {
                      if (value) {
                        theme.setTheme(ThemeData.dark());
                      } else {
                        theme.setTheme(ThemeData.light());
                      }
                    },
                  ),
                ),
              ],
            ),
            SettingsSection(
              title: Text('Delete Account',style: TextStyle(
                  fontWeight: FontWeight.w500,fontSize:17
              )),
              tiles: [
                SettingsTile(
                  title: Text('Delete Account', style: titleStyle),
                  leading: Icon(Icons.delete),
                  onPressed: (BuildContext context) async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    int userId = prefs.getInt('userId') ?? 0;
                    deleteUser(userId);
                    await deleteUser(userId);
                    bool isDelete = true;
                    if (isDelete) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(
                            showRegisterPage: () {},
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Account Deleted'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Account Could Not Be Deleted'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    padding: EdgeInsets.all(8), // Kutunun iç boşluğunu ayarlamak için padding kullanıyoruz
                    child: Center(
                      child: Text(
                        'SIGN OUT',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  onPressed: (BuildContext context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(
                          showRegisterPage: () {},
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}