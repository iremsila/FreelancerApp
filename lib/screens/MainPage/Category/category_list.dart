import 'package:flutter/material.dart';
import 'category_jobs.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text('Categories'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          CategoryCard(
            image: AssetImage('assets/images/web_design.png'),
            title: 'Web Design',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryJobsPage(category: 'Web Design'),
                ),
              );
            },
          ),
          CategoryCard(
            image: AssetImage('assets/images/graphic_design.png'),
            title: 'Graphic Design',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryJobsPage(category: 'Graphic Design'),
                ),
              );
            },
          ),
          CategoryCard(
            image: AssetImage('assets/images/software_development.png'),
            title: 'Software Development',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryJobsPage(category: 'Software Development'),
                ),
              );
            },
          ),
          CategoryCard(
            image: AssetImage('assets/images/mobile_development.png'),
            title: 'Mobile App Development',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryJobsPage(category: 'Mobile App Development'),
                ),
              );
            },
          ),
          CategoryCard(
            image: AssetImage('assets/images/digital_marketing.png'),
            title: 'Digital Marketing',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryJobsPage(category: 'Digital Marketing'),
                ),
              );
            },
          ),
          CategoryCard(
            image: AssetImage('assets/images/content-writing.png'),
            title: 'Content Writing',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryJobsPage(category: 'Content Writing'),
                ),
              );
            },
          ),
          CategoryCard(
            image: AssetImage('assets/images/languages.png'),
            title: 'Translation',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryJobsPage(category: 'Translation'),
                ),
              );
            },
          ),
          CategoryCard(
            image: AssetImage('assets/images/data_entry.png'),
            title: 'Data Entry',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryJobsPage(category: 'Data Entry'),
                ),
              );
            },
          ),
          CategoryCard(
            image: AssetImage('assets/images/voiceover.png'),
            title: 'Voiceover',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryJobsPage(category: 'Voiceover'),
                ),
              );
            },
          ),
          CategoryCard(
            image: AssetImage('assets/images/montage.png'),
            title: 'Video Editing',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryJobsPage(category: 'Video Editing'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final ImageProvider<Object> image;
  final String title;
  final VoidCallback onTap;

  const CategoryCard({
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
