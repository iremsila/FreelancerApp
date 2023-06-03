import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<List<Map<String, dynamic>>> fetchApplications() async {
    final conn = await getConnection();

    final results = await conn
        .query('SELECT * FROM job_applications WHERE job_id = ?', [job['id']]);

    final applications = results.map((result) => result.fields).toList();

    await conn.close();

    return applications;
  }

  Future<Map<String, dynamic>> fetchUser(int freelancerId) async {
    final conn = await getConnection();

    final results =
        await conn.query('SELECT * FROM User WHERE id = ?', [freelancerId]);

    final user = results.first.fields;

    await conn.close();

    return user;
  }

  void showApplications(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    final conn = await getConnection();

    try {
      // Kullanıcının işçi olarak kayıtlı olup olmadığını kontrol et
      final results = await conn.query(
        'SELECT * FROM User WHERE id = ? AND freelanceroremployer = "Employer"',
        [userId],
      );

      if (results.isNotEmpty) {
        // Kullanıcı işçi, başvuruları göster
        final applications = await fetchApplications();

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Applicants for ${job['job_title']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    applications.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: applications.length,
                            itemBuilder: (context, index) {
                              final application = applications[index];
                              final int freelancerId =
                                  application['freelancer_id'];
                              return FutureBuilder(
                                future: fetchUser(freelancerId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox(
                                      width: 40.0,
                                      height: 40.0,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final user =
                                        snapshot.data as Map<String, dynamic>;
                                    return ListTile(
                                      title: Text('${user['nameandsurname']}'),
                                      subtitle: Text('${user['email']}'),
                                    );
                                  }
                                },
                              );
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // Kullanıcı işveren, hata mesajı göster
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Freelancers cannot view applicants!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Okay'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Başvuruları görüntüleme sırasında bir hata oluştu: $e');
    } finally {
      await conn.close();
    }
  }

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
                GestureDetector(
                  onTap: () => showApplications(context),
                  child: Image.asset(
                    'assets/images/application.png',
                    width: 30.0,
                    height: 30.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
