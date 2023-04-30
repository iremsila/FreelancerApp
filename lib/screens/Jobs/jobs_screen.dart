import 'package:flutter/material.dart';
import '../../Widget/bottom_nav_bar.dart';
import '../Category/category1_page.dart';
import '../Search/search_job.dart';

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
    return Container(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
        appBar: AppBar(
          backgroundColor: Colors.blue.shade200,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.filter_list_rounded,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_outlined, color: Colors.black),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (c) => const SearchScreen()));
              },
            )
          ],
        ),
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
                  fontFamily: 'Valera',
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
                      fontFamily: 'Valera',
                      fontSize: 21,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Category 2',
                    style: TextStyle(
                      fontFamily: 'Valera',
                      fontSize: 21,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Category 3',
                    style: TextStyle(
                      fontFamily: 'Valera',
                      fontSize: 21,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Category 4',
                    style: TextStyle(
                      fontFamily: 'Valera',
                      fontSize: 21,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Category 5',
                    style: TextStyle(
                      fontFamily: 'Valera',
                      fontSize: 21,
                    ),
                  ),
                )
              ],
            ),
            Container(
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
      ),
    );
  }
}
