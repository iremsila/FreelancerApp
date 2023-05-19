import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart' as mysql;
class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final settings = mysql.ConnectionSettings(
    host: '213.238.183.81',
    port: 3306,
    user: 'httpdegm_melike',
    password: 'A}c74e&QAI[x',
    db: 'httpdegm_database1',
  );

  List<String> searchResults = [];

  void search(String query) async {
    final conn = await mysql.MySqlConnection.connect(settings);

    final results = await conn.query('SELECT * FROM upload_job WHERE job_title LIKE ? OR category LIKE ? OR location LIKE ? OR description LIKE ? OR budget LIKE ?', ['%$query%', '%$query%', '%$query%', '%$query%', '%$query%']);

    setState(() {
      searchResults = results.map((r) {
        return '${r['job_title']}, ${r['category']}, ${r['location']}, ${r['description']}, ${r['budget']}';
      }).toList();
    });

    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              onChanged: search,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchResults[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
