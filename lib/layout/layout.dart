import 'package:FreelancerApp/screens/Jobs/jobs_screen.dart';
import 'package:flutter/material.dart';
import '../shared/items/widgets.dart';
import '../shared/resources/styles.dart';

class AppLayOut extends StatelessWidget {
  const AppLayOut(
      {super.key,
      this.leading,
      required this.header,
      required this.dis,
      this.fields});

  final Widget? leading, fields;
  final String header, dis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: leading,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JobScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // page header
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        header,
                        style: AppStyles.large(),
                      ),
                    ],
                  ),
                  freev(v: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      child: Text(
                        dis,
                        style: AppStyles.light(),
                      ),
                    ),
                  ),
                ],
              ),
              freev(v: 45),
              //fields
              fields ?? const SizedBox(),
              freev(v: 45),
              //bottom
            ],
          ),
        ),
      ),
    );
  }
}
