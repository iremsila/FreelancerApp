import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter/widgets.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _tokenController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  late String _resetToken;
  bool _tokenMatched = false;
  bool _passwordReset = false;
  MySqlConnection? _connection;

  @override
  void dispose() {
    _connection?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: !_passwordReset
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue.shade900),
                      ),
                      onPressed: _sendResetEmail,
                      child: Text('Send Reset Email'),
                    ),
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter New Password',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _tokenController,
                    decoration: InputDecoration(
                      labelText: 'Token',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue.shade900),
                    ),
                    onPressed: _resetPassword,
                    child: Text('Reset Password'),
                  ),
                ],
              ),
      ),
    );
  }

  void _sendResetEmail() async {
    await _connectToDatabase();

    String email = _emailController.text;

    if (!await _checkEmailExists(email)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Email'),
            content: Text('The entered email does not exist.'),
            actions: [
              TextButton(
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

    _resetToken = _generateToken();

    final smtpServer = gmail(
      'melikesoygullucu@gmail.com',
      'dbqbsgfbykhvchoe',
    );

    final message = Message()
      ..from = Address('melikesoygullucu@gmail.com')
      ..recipients.add(email)
      ..subject = 'Password Reset'
      ..text = 'Your password reset token is: $_resetToken';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. ' + e.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to send reset email.'),
            actions: [
              TextButton(
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

    await _saveTokenToDatabase(email, _resetToken);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Email Sent'),
          content: Text('Reset email has been sent to $email.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _passwordReset = true;
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _resetPassword() async {
    await _connectToDatabase();

    String email = _emailController.text;
    String token = _tokenController.text;
    String newPassword = _newPasswordController.text;

    if (!await _checkEmailExists(email)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Email'),
            content: Text('The entered email does not exist.'),
            actions: [
              TextButton(
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

    if (await _checkTokenFromDatabase(email, token)) {
      await _updatePassword(email, newPassword);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset Successful'),
            content: Text('Your password has been successfully reset.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Token'),
            content: Text('The token you entered is invalid.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _connectToDatabase() async {
    final settings = ConnectionSettings(
      host: '213.238.183.81',
      port: 3306,
      user: 'httpdegm_melike',
      password: 'A}c74e&QAI[x',
      db: 'httpdegm_database1',
    );

    _connection = await MySqlConnection.connect(settings);
  }

  Future<bool> _checkEmailExists(String email) async {
    final result = await _connection?.query(
      'SELECT * FROM User WHERE email = ?',
      [email],
    );

    return result?.isNotEmpty ?? false;
  }

  Future<void> _saveTokenToDatabase(String email, String token) async {
    await _connection?.query(
      'UPDATE User SET token = ? WHERE email = ? ',
      [token, email],
    );
  }

  Future<bool> _checkTokenFromDatabase(String email, String token) async {
    final result = await _connection?.query(
      'SELECT * FROM User WHERE email = ? AND token = ?',
      [email, token],
    );

    return result?.isNotEmpty ?? false;
  }

  Future<void> _updatePassword(String email, String password) async {
    await _connection?.query(
      'UPDATE User SET password = ? WHERE email = ?',
      [password, email],
    );
  }

  String _generateToken() {
    Random random = Random();
    const int tokenLength = 6;
    const String chars = '0123456789';
    String token = '';

    for (int i = 0; i < tokenLength; i++) {
      token += chars[random.nextInt(chars.length)];
    }

    return token;
  }
}
