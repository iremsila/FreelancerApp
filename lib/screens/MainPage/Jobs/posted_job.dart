import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'job_card.dart';
import 'job_detail.dart';

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
        fetchDataFromDatabase();
      });
    });
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

  Future<String> fetchUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    var conn = await getConnection();
    var results = await conn.query(
      'SELECT freelanceroremployer FROM User WHERE id = ?',
      [userId],
    );
    await conn.close();
    if (results.isNotEmpty) {
      var row = results.first;
      return row['freelanceroremployer'];
    } else {
      return '';
    }
  }

  Future<void> fetchDataFromDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    var conn = await getConnection();

    String query = '';

    if (userRole == 'Freelancer') {
      query =
          'SELECT j.* FROM job_applications ja INNER JOIN upload_job1 j ON ja.job_id = j.id WHERE ja.freelancer_id = ?';
    } else if (userRole == 'Employer') {
      query = 'SELECT * FROM upload_job1 WHERE user_id = ?';
    } else {
      // Diğer durumlar için bir hata durumu veya varsayılan sorgu belirleyebilirsiniz
      // Örneğin:
      throw Exception('Geçersiz kullanıcı rolü: $userRole');
      // veya:
    }
    if (query.isNotEmpty) {
      final jobResult = await conn.query(query, [userId]);
      if (jobResult.isNotEmpty) {
        setState(() {
          jobList = jobResult.map((row) => row.fields).toList();
        });
      }
    }
    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    String title = '';
    if (userRole == 'Employer') {
      title = 'Jobs You Posted';
    } else if (userRole == 'Freelancer') {
      title = 'Jobs You Applied';
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
      ),
      body: ListView.builder(
        itemCount: jobList.length,
        itemBuilder: (context, index) {
          final job = jobList[index];
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
