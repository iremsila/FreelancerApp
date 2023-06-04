import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';

class JobCard2 extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobCard2({required this.job});

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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
