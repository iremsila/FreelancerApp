import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../Jobs/job_card_2.dart';
import '../Jobs/job_detail.dart';

class CategoryJobsPage extends StatefulWidget {
  final String category;

  const CategoryJobsPage({required this.category});

  @override
  _CategoryJobsPageState createState() => _CategoryJobsPageState();
}

class _CategoryJobsPageState extends State<CategoryJobsPage> {
  List<Map<String, dynamic>> _jobs = [];

  @override
  void initState() {
    super.initState();
    _fetchJobsByCategory();
  }

  Future<void> _fetchJobsByCategory() async {
    final settings = ConnectionSettings(
      host: '213.238.183.81',
      port: 3306,
      user: 'httpdegm_hudai',
      password: ',sPE[gd^hbl1',
      db: 'httpdegm_database1',
    );

    final conn = await MySqlConnection.connect(settings);

    final results = await conn.query(
      'SELECT * FROM upload_job1 WHERE category = ?',
      [widget.category],
    );

    final List<Map<String, dynamic>> jobs = [];
    for (var row in results) {
      final Map<String, dynamic> rowData = Map.from(row.fields);
      jobs.add(rowData);
    }

    setState(() {
      _jobs = jobs;
    });

    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text(widget.category),
      ),
      body: ListView.builder(
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobDetailPage(job),
                ),
              );
            },
            child: JobCard2(job: job),
          );
        },
      ),
    );
  }
}
