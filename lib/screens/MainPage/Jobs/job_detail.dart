import 'dart:ui';
import 'package:WorkWise/screens/MainPage/Jobs/posted_job.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../constans/colors.dart';

class JobDetailPage extends StatelessWidget {
  final Map<String, dynamic> jobData;

  JobDetailPage(this.jobData);

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
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Budget",
                    style: GoogleFonts.openSans(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
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
                  onPressed: () {},
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
