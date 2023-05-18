import 'package:WorkWise/screens/MainPage/Jobs/upload_job.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
        title: Text(
          'WorkWise',
          style:
              GoogleFonts.openSans(fontSize: 30, fontWeight: FontWeight.bold),
        ),
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
                child: Text(
                  "POST JOB NOW",
                  style: GoogleFonts.openSans(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
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
              separatorBuilder: (context, _) => const SizedBox(width: 5),
              itemBuilder: (context, index) => buildCard(item: items[index]),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                "  Explore beautiful work,\n  picked for you.",
                style: GoogleFonts.openSans(fontSize: 25),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        spreadRadius: 3,
                        offset: Offset(3, 4),
                      )
                    ],
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailPage(jobs[index]),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                    ),
                    title: Text(
                      jobs[index]['job_title'],
                      style: GoogleFonts.openSans(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(jobs[index]['location'],
                            style: GoogleFonts.openSans()),
                        SizedBox(height: 20), // İki metin arasına boşluk ekler
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${jobs[index]['budget']}',
                              style: GoogleFonts.openSans(),
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd').format(
                                jobs[index]['date_posted'],
                              ),
                              style: GoogleFonts.openSans(),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                Text(item.title,
                    style: GoogleFonts.openSans(
                        fontSize: 10, fontWeight: FontWeight.bold)),
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
