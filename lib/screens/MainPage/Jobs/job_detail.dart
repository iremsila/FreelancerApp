import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../provider/theme_provider.dart';

class JobDetailPage extends StatefulWidget {
  late final Map<String, dynamic> jobData;

  JobDetailPage(this.jobData);

  @override
  _JobDetailPageState createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  int _applicationCount = 0;
  StreamController<int> _applicationCountController = StreamController<int>();

  Stream<int> get applicationCountStream => _applicationCountController.stream;

  int get applicationCount => _applicationCount;

  set applicationCount(int value) {
    _applicationCount = value;
    _applicationCountController.add(value);
  }

  TextEditingController commentController =
      TextEditingController(); // Yorum girilen metni tutacak controller
  List<Comment> comments = []; // Yorumların tutulduğu liste

  @override
  void initState() {
    super.initState();
    applicationCount = widget.jobData['application_count'] as int? ?? 0;
    fetchComments();
  }

  Future<void> fetchComments() async {
    final conn = await getConnection();

    try {
      final results = await conn.query(
        'SELECT c.comment, u.nameandsurname FROM job_comments c INNER JOIN User u ON c.user_id = u.id WHERE c.job_id = ?',
        [widget.jobData['id']],
      );

      List<Comment> fetchedComments = [];
      for (var row in results) {
        fetchedComments.add(
          Comment(
            comment: row['comment'],
            userName: row['nameandsurname'],
          ),
        );
      }

      setState(() {
        comments = fetchedComments;
      });
    } catch (e) {
      print('An error occurred while fetching comments: $e');
    } finally {
      await conn.close();
    }
  }

  Future<void> saveComment(String comment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    final conn = await getConnection();

    try {
      await conn.query(
        'INSERT INTO job_comments (job_id, user_id, comment) VALUES (?, ?, ?)',
        [widget.jobData['id'], userId, comment],
      );

      setState(() {
        comments.insert(
          0,
          Comment(
            comment: comment,
            userName: widget.jobData['nameandsurname'],
          ),
        );
      });
    } catch (e) {
      print('An error occurred while saving comment: $e');
    } finally {
      await conn.close();
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
        [userId, widget.jobData['id']],
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
        [userId, widget.jobData['id']],
      );

      String applicantName = await getApplicantName(userId, conn);
      String jobTitle = widget.jobData['job_title'];
      String message = '$applicantName has applied for $jobTitle';
      await conn.query(
        'INSERT INTO notifications (sender_id, job_id, is_read, receiver_id, message) VALUES (?, ?, ?, ?, ?)',
        [userId, widget.jobData['id'], 0, widget.jobData['user_id'], message],
      );

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Your application has been successfully completed!'),
        ),
      );

      // Increase the applicationCount by 1
      setState(() {
        applicationCount++;
      });
      _applicationCountController.add(applicationCount);

      // Güncellenen application_count değerini veritabanına kaydet
      await conn.query(
        'UPDATE upload_job1 SET application_count = ? WHERE id = ?',
        [applicationCount, widget.jobData['id']],
      );

      // Güncellenen job verilerini yeniden getir
      final updatedJobResults = await conn.query(
        'SELECT * FROM upload_job1 WHERE id = ?',
        [widget.jobData['id']],
      );

      if (updatedJobResults.isNotEmpty) {
        setState(() {
          widget.jobData = updatedJobResults.first.fields;
        });
      }
    } catch (e) {
      print('An error occurred during the application: $e');
    } finally {
      await conn.close();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset("assets/images/logo.png"),
            ),
            Padding(
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25)),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              maxChildSize: 1,
              minChildSize: 0.6,
              builder: (context, scrollController) {
                final themeProviderData = context.read<ThemeProvider>();
                final bool isLightTheme =
                    themeProviderData.getTheme().brightness == Brightness.light;
                final Color textColor2 =
                    isLightTheme ? Colors.black : Colors.white;

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: isLightTheme ? Colors.white : Color(0xFF303030),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
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
                                color: Colors.black12,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          widget.jobData['job_title'],
                          style: GoogleFonts.openSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor2,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.jobData['location'],
                          style: GoogleFonts.openSans(
                            fontSize: 15,
                            color: textColor2,
                          ),
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
                              widget.jobData['category'],
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColor2,
                              ),
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(widget.jobData['date_posted']),
                                  style: GoogleFonts.openSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: textColor2,
                                  ),
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
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: textColor2,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.jobData['description'],
                            style: GoogleFonts.openSans(
                              fontSize: 15,
                              color: textColor2,
                            ),
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textColor2,
                                ),
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  size: 30,
                                  color: textColor2,
                                ),
                                const SizedBox(width: 5),
                                StreamBuilder<int>(
                                  stream: applicationCountStream,
                                  initialData: applicationCount,
                                  builder: (context, snapshot) {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: GoogleFonts.openSans(
                                        fontSize: 20,
                                        color: textColor2,
                                      ),
                                    );
                                  },
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
                            '\$${widget.jobData['budget']}',
                            style: GoogleFonts.openSans(
                              fontSize: 15,
                              color: textColor2,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            applyJob(context);
                          },
                          child: Text(
                            "Apply",
                            style: GoogleFonts.openSans(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: textColor2,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            elevation: 5,
                            fixedSize: Size(150, 50),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.blue.shade900),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Comments',
                                    style: GoogleFonts.openSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: textColor2,
                                    ),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      comments[index].userName,
                                      style: TextStyle(
                                          color: textColor2,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      comments[index].comment,
                                      style: TextStyle(color: textColor2),
                                    ),
                                  );
                                },
                              ),
                              TextField(
                                controller: commentController,
                                style: TextStyle(color: textColor2),
                                decoration: InputDecoration(
                                  hintText: 'Write a comment',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .black), // Border rengini siyah yapar
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .black), // Focused border rengi
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      saveComment(commentController.text);
                                      commentController.clear();
                                      fetchComments();
                                    },
                                    icon: Icon(
                                      Icons.send,
                                      color: textColor2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Comment {
  final String comment;
  final String userName;

  Comment({
    required this.comment,
    required this.userName,
  });
}
