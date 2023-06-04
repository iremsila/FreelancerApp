import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constans/colors.dart';

class JobDetailPage extends StatelessWidget {
  final Map<String, dynamic> jobData;

  JobDetailPage(this.jobData);

  Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: '213.238.183.81',
      port: 3306,
      user: 'httpdegm_hudai',
      password: ',sPE[gd^hbl1',
      db: 'httpdegm_database1',
    );
    return await MySqlConnection.connect(settings);
  }

  Future<String> getApplicantName(int userId, MySqlConnection conn) async {
    final result = await conn.query(
      'SELECT nameandsurname FROM User WHERE id = ?',
      [userId],
    );

    if (result.isNotEmpty) {
      return result.first['nameandsurname'];
    } else {
      return 'Unknown'; // Default name if user is not found
    }
  }

  Future<void> applyJob(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    final conn = await getConnection();

    try {
      // Kullanıcının işveren olarak kayıtlı olup olmadığını kontrol et
      final results = await conn.query(
        'SELECT * FROM User WHERE id = ? AND freelanceroremployer = "Employer"',
        [userId],
      );

      if (results.isNotEmpty) {
        // Kullanıcı işveren, apply tuşunu görünmez yap
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Employers cannot apply!'),
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
        return;
      }

      // Kullanıcı işçi, başvuru işlemini gerçekleştir

      // Kullanıcının aynı işe başvurup başvurmadığını kontrol et
      final applicationResults = await conn.query(
        'SELECT * FROM job_applications WHERE freelancer_id = ? AND job_id = ?',
        [userId, jobData['id']],
      );

      if (applicationResults.isNotEmpty) {
        // Kullanıcı zaten bu işe başvurmuş
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('You have already applied for this job!'),
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
        return;
      }

      // Başvuru kaydını ekle
      await conn.query(
        'INSERT INTO job_applications (freelancer_id, job_id) VALUES (?, ?)',
        [userId, jobData['id']],
      );

      await conn.query(
        'UPDATE upload_job1 SET application_count = application_count + 1 WHERE id = ?',
        [jobData['id']],
      );
      String applicantName = await getApplicantName(userId, conn);
      String jobTitle = jobData['job_title'];
      String message = '$applicantName has applied for $jobTitle';
      await conn.query(
        'INSERT INTO notifications (sender_id, job_id, is_read, receiver_id, message) VALUES (?, ?, ?, ?, ?)',
        [userId, jobData['id'], 0, jobData['user_id'], message],
      );

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Your application has been successfully completed!'),
        ),
      );
    } catch (e) {
      print('An error occurred during the application: $e');
    } finally {
      await conn.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset("assets/images/logo.png"),
              ),
              buttonArrow(context),
              scroll(),
            ],
          ),
        ),
      ),
    );
  }

  buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
                height: 55,
                width: 55,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(25)),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.white,
                )),
          ),
        ),
      ),
    );
  }

  scroll() {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 1,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 5,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                Text(
                  jobData['job_title'],
                  style: GoogleFonts.openSans(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  jobData['location'],
                  style:
                      GoogleFonts.openSans(fontSize: 15, color: SecondaryText),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      jobData['category'],
                      style: GoogleFonts.openSans(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd')
                              .format(jobData['date_posted']),
                          style: GoogleFonts.openSans(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Divider(
                    height: 4,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Job Description",
                    style: GoogleFonts.openSans(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    jobData['description'],
                    style: GoogleFonts.openSans(
                        fontSize: 15, color: SecondaryText),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(
                    height: 4,
                  ),
                ),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Budget",
                        style: GoogleFonts.openSans(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 30,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          jobData['application_count'] != null
                              ? "${jobData['application_count']}"
                              : "0",
                          style: GoogleFonts.openSans(
                              fontSize: 20, color: SecondaryText),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '\$${jobData['budget']}',
                    style: GoogleFonts.openSans(fontSize: 15),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    applyJob(context);
                  },
                  child: Text(
                    "Apply",
                    style: GoogleFonts.openSans(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    elevation: 5,
                    fixedSize: Size(150, 50),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.cyan.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
