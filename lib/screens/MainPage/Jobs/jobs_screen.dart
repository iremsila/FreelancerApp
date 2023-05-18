import 'package:WorkWise/screens/MainPage/Jobs/upload_job.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'job_detail.dart';

class JobScreen extends StatefulWidget {
  JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> jobs = [];
  String userRole = '';

  @override
  void initState() {
    super.initState();
    fetchUserRole().then((role) {
      setState(() {
        userRole = role;
      });
    });
    fetchData().then((data) {
      setState(() {
        jobs = data;
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    var conn = await getConnection();
    var results = await conn.query('SELECT * FROM upload_job');
    await conn.close();
    return results.map((resultRow) {
      return Map<String, dynamic>.from(resultRow.fields);
    }).toList();
  }

  Future<String> fetchUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    var conn = await getConnection();
    var results = await conn.query(
      'SELECT freelanceroremployer FROM User WHERE id = ?',
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

  List<CardItem> items = [
    CardItem(
      urlImage: 'assets/images/AI.jpg',
      title: 'AI Artist',
    ),
    CardItem(
      urlImage: 'assets/images/logo.webp',
      title: 'Logo Design',
    ),
    CardItem(
      urlImage: 'assets/images/software.jpg',
      title: 'Software Development',
    ),
    CardItem(
      urlImage: 'assets/images/video_editing.webp',
      title: 'Video Editing',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.white,
        title: Text('WorkWise',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        elevation: 2,
        actions: [
          // Kullanıcı işveren ise düğmeyi göster
          if (userRole == 'Employer')
            Padding(
              padding: EdgeInsets.only(right: 16, bottom: 8),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadJobNow()),
                  );
                },
                child: Text("POST JOB NOW"),
                style: TextButton.styleFrom(
                  elevation: 5,
                  fixedSize: Size(150, 25),
                  foregroundColor: Colors.cyan[900],
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            children: [
              Text(
                "  Popular Services",
                textAlign: TextAlign.start,
                style: GoogleFonts.openSans(
                    fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 130,
            child: ListView.separated(
              padding: const EdgeInsets.all(5),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (context, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) => buildCard(item: items[index]),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                "  Explore beautiful work,\n  picked for you.",
                style: GoogleFonts.openSans(
                    fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(jobs[index]['job_title']),
                    subtitle: Text(jobs[index]['description']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailPage(jobs[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard({
    required CardItem item,
  }) =>
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 130,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: AspectRatio(
                      aspectRatio: 4 / 2,
                      child: Image.asset(
                        item.urlImage,
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(height: 8),
                Text(item.title, style: GoogleFonts.anton(fontSize: 13)),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      );
}

class CardItem {
  final String urlImage;
  final String title;

  CardItem({required this.urlImage, required this.title});
}
