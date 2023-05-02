import 'package:flutter/material.dart';

import '../Category/category1_page.dart';


class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  //For testing
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // From this for demo
      body: ListView(
        padding: const EdgeInsets.only(left: 20),
        children: <Widget>[
          const SizedBox(
            height: 15,
          ),
          const Text(
            'Categories',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 42,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            labelColor: const Color(0xFFC88D67),
            isScrollable: true,
            labelPadding: const EdgeInsets.only(right: 45),
            unselectedLabelColor: const Color(0xFFCDCDCD),
            tabs: const [
              Tab(
                child: Text(
                  'Category 1',
                  style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 21,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Category 2',
                  style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 21,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Category 3',
                  style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 21,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Category 4',
                  style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 21,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Category 5',
                  style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 21,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 10,
            width: double.infinity,
            child: TabBarView(
              controller: _tabController,
              children: const [
                Category1Page(),
                Category1Page(),
                Category1Page(),
                Category1Page(),
                Category1Page(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
