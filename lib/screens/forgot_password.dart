import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mysql1/mysql1.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Enter your email and we'll send you a password reset link to your email.",
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
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              sendPasswordResetEmail(_emailController.text);
            },
            child: Text("Password Reset"),
          ),
        ],
      ),
    );
  }

  void sendPasswordResetEmail(String email) async {
    final smtpServer = gmail('workwiise@gmail.com', 'workwise1234');
    final message = Message()
      ..from = Address('workwiise@gmail.com')
      ..recipients.add(email)
      ..subject = 'Password Reset'
      ..text = 'Here is your password reset link.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email has been sent.'),
        ),
      );
      updatePasswordInDatabase(
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      print('Error occurred while sending email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while sending the email.'),
        ),
      );
    }
  }

  void updatePasswordInDatabase(String email, String newPassword) async {
    final settings = ConnectionSettings(
      host: 'your-host',
      port: 3306,
      user: 'your-username',
      password: 'your-password',
      db: 'your-database',
    );

    final conn = await MySqlConnection.connect(settings);
    await conn.query(
      'UPDATE User SET password = ? WHERE email = ?',
      [newPassword, email],
    );
    await conn.close();
  }
}
