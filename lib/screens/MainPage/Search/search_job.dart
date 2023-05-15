import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import '../Jobs/job_detail.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _performSearch(String? keyword) async {
    final settings = ConnectionSettings(
      host: '213.238.183.81',
      port: 3306,
      user: 'httpdegm_melike',
      password: 'A}c74e&QAI[x',
      db: 'httpdegm_database1',
    );

    final conn = await MySqlConnection.connect(settings);

    final results = await conn.query(
      'SELECT * FROM upload_job WHERE category LIKE ? OR location LIKE ? OR job_title LIKE ? ',
      ['%$keyword%', '%$keyword%', '%$keyword%'],
    );

    final List<Map<String, dynamic>> searchResults = [];
    for (var row in results) {
      final Map<String, dynamic> rowData = Map.from(row.fields);
      searchResults.add(rowData);
    }

    setState(() {
      _searchResults = searchResults;
    });

    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchResults.clear(); // Önceki arama sonuçlarını temizle
                });
                if (value.isNotEmpty) {
                  _performSearch(value);
                }
              },
              decoration: InputDecoration(
                hintText: 'Search',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return ListTile(
                  title: Text(result['category']),
                  subtitle: Text(result['location']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailPage(result),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
