import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  String _email = '';

  Future<void> _fetchUserData() async {
    final settings = ConnectionSettings(
      host: '213.238.183.81',
      port: 3306,
      user: 'httpdegm_melike',
      password: 'A}c74e&QAI[x',
      db: 'httpdegm_database1',
    );

    final conn = await MySqlConnection.connect(settings);

    final results =
        await conn.query('SELECT nameandsurname, email FROM User WHERE id = 9');
    if (results.isNotEmpty) {
      final row = results.first;
      setState(() {
        _name = row['nameandsurname'];
        _email = row['email'];
      });
    }

    await conn.close();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _name,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _email,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
