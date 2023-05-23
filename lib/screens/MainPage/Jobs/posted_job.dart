import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobListScreen extends StatefulWidget {
  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  List<Map<String, dynamic>> jobList = [];
  String userRole = '';
  @override
  void initState() {
    super.initState();
    fetchUserRole().then((role) {
      setState(() {
        userRole = role;
      });
    });
    fetchDataFromDatabase();
  }

  Future<String> fetchUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    var conn = await getConnection();
    var results = await conn.query(
      'SELECT freelanceroremployer FROM User WHERE id = ? ',
      [userId],
    ); // Kullanıcının kimlik bilgisine göre sorguyu güncelleyin
    await conn.close();
    if (results.isNotEmpty) {
      var row = results.first;
      return row['freelanceroremployer'];
    } else {
      return ''; // Varsayılan rol değeri, eğer kullanıcının rolü bulunamazsa
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

  Future<void> fetchDataFromDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '213.238.183.81',
      port: 3306,
      user: 'httpdegm_hudai',
      password: ',sPE[gd^hbl1',
      db: 'httpdegm_database1',
    ));

    final jobResult = await conn.query(
      'SELECT * FROM upload_job1 WHERE user_id = ? ',
      [userId],
    );

    if (jobResult.isNotEmpty) {
      setState(() {
        jobList = jobResult.map((row) => row.fields).toList();
      });
    }

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
          title: (userRole == 'Freelancer')
              ? Text(
                  'Job You Applied',
                  style: GoogleFonts.openSans(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              : Text(
                  'Job You Posted',
                  style: GoogleFonts.openSans(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
          elevation: 2,
        ),
        body: ListView.builder(
          itemCount: jobList.length,
          itemBuilder: (context, index) {
            final job = jobList[index];
            if (userRole == 'Employer') {
              return ListTile(
                title: Text(job['job_title']),
                subtitle: Text(job['category']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailScreen(job: job),
                    ),
                  );
                },
              );
            } else {
              return ListTile();
            }
          },
        ));
  }
}

class JobDetailScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailScreen({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job Title: ${job['job_title']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Category: ${job['category']}'),
            SizedBox(height: 8.0),
            Text('Location: ${job['location']}'),
            SizedBox(height: 8.0),
            Text('Description: ${job['description']}'),
            SizedBox(height: 8.0),
            Text('Budget: ${job['budget']}'),
            SizedBox(height: 8.0),
            Text('Date Posted: ${job['date_posted']}'),
          ],
        ),
      ),
    );
  }
}
