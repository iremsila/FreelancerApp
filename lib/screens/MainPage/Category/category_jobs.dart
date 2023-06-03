import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
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
            child: JobCard(job: job),
          );
        },
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['job_title'],
              style: GoogleFonts.openSans(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              job['location'],
              style: GoogleFonts.openSans(fontSize: 14.0),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${job['budget']}',
                  style: GoogleFonts.openSans(),
                ),
                Text(
                  DateFormat('yyyy-MM-dd').format(
                    job['date_posted'],
                  ),
                  style: GoogleFonts.openSans(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
