import 'package:WorkWise/screens/MainPage/Jobs/upload_job.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Category/category_jobs.dart';
import '../Category/category_list.dart';
import 'job_card_2.dart';
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
              SizedBox(width: 16), // Başlangıçtan boşluk ekledik
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
                            fontSize: 16, // See All metni daha küçük
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16),
                        // Okun boyutunu küçülttük
                      ],
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: EdgeInsets.zero,
                      // Buton kenar boşlukları
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap, // Buton boyutu
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16), // Sondan boşluk ekledik
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
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
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
              ));
        },
        child: Container(
          height: 60,
          width: 120,
          decoration: BoxDecoration(
            color: Color(0xfffafbfd),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      item.urlImage,
                    )),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  // Metni ortalamak için textAlign özelliğini ekledik
                  style: GoogleFonts.openSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
