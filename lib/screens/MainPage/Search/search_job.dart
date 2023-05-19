import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
      user: 'httpdegm_hudai',
      password: ',sPE[gd^hbl1',
      db: 'httpdegm_database1',
    );

    final conn = await MySqlConnection.connect(settings);

    final results = await conn.query(
      'SELECT * FROM upload_job1 WHERE category LIKE ? OR location LIKE ? OR job_title LIKE ? ',
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle:
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.white,
        title: Text(
          'Discover & Search',
          style: GoogleFonts.openSans(
              fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 2,
      ),
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