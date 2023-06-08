import 'dart:async';

import 'package:WorkWise/screens/MainPage/Jobs/upload_job.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../provider/theme_provider.dart';
import '../Category/category_jobs.dart';
import '../Category/category_list.dart';
import 'job_card_2.dart';
import 'job_detail.dart';

class JobScreen extends StatefulWidget {
  JobScreen({Key? key}) : super(key: key);

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> jobs = [];
  String userRole = '';
  StreamController<List<Map<String, dynamic>>> _streamController =
      StreamController<List<Map<String, dynamic>>>();

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
      _streamController.add(jobs);
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    var conn = await getConnection();
    var results =
        await conn.query('SELECT * FROM upload_job1 ORDER BY date_posted ASC');
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
    );
    await conn.close();
    if (results.isNotEmpty) {
      var row = results.first;
      return row['freelanceroremployer'];
    } else {
      return '';
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
      urlImage: 'assets/images/mobile_development.png',
      title: 'Mobile App Development',
    ),
    CardItem(
      urlImage: 'assets/images/content-writing.png',
      title: 'Content Writing',
    ),
    CardItem(
      urlImage: 'assets/images/software_development.png',
      title: 'Software Development',
    ),
    CardItem(
      urlImage: 'assets/images/montage.png',
      title: 'Video Editing',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProviderData = Provider.of<ThemeProvider>(context);
    final ThemeData appTheme = themeProviderData.getTheme();
    final Color appBarBackgroundColor = appTheme.brightness == Brightness.light
        ? Colors.white
        : appTheme.scaffoldBackgroundColor;
    final Color appBarForegroundColor =
        appTheme.brightness == Brightness.light ? Colors.black : Colors.white;
    final TextStyle titleStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: appBarForegroundColor,
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: appBarBackgroundColor,
        title: Text(
          'WorkWise',
          style: titleStyle,
        ),
        elevation: 2,
        actions: [
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
      backgroundColor: appTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            children: [
              SizedBox(width: 16),
              Text(
                "Popular Services",
                textAlign: TextAlign.start,
                style: GoogleFonts.openSans(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoriesPage()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "See All",
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
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
              itemBuilder: (context, index) => _categories(item: items[index]),
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
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Hata: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final newData = snapshot.data!;

                return RefreshIndicator(
                  onRefresh: () async {
                    final data = await fetchData();
                    setState(() {
                      jobs = data;
                    });
                    _streamController.add(jobs);
                  },
                  child: ListView.builder(
                    itemCount: newData.length,
                    itemBuilder: (context, index) {
                      final job = newData[index];
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
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categories({
    required CardItem item,
  }) =>
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryJobsPage(category: item.title),
            ),
          );
        },
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                item.urlImage,
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 5),
              Text(
                item.title,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
}

class CardItem {
  final String urlImage;
  final String title;

  CardItem({
    required this.urlImage,
    required this.title,
  });
}
