import 'package:flutter/material.dart';

class Category1Page extends StatelessWidget {
  const Category1Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: const EdgeInsets.only(right: 15),
            width: MediaQuery.of(context).size.width - 30,
            height: 500,
            child: GridView.count(
              crossAxisCount: 2,
              primary: false,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
              childAspectRatio: 0.8,
              children: <Widget>[
                _buildCard('Name1', 'Description1',
                    'https://logowik.com/content/uploads/images/flutter5786.jpg'),
                _buildCard('Name2', 'Description2',
                    'https://logowik.com/content/uploads/images/flutter5786.jpg'),
                _buildCard('Name3', 'Description3',
                    'https://logowik.com/content/uploads/images/flutter5786.jpg'),
                _buildCard('Name4', 'Description4',
                    'https://logowik.com/content/uploads/images/flutter5786.jpg'),
                _buildCard('Name5', 'Description5',
                    'https://logowik.com/content/uploads/images/flutter5786.jpg'),
                _buildCard('Name6', 'Description6',
                    'https://logowik.com/content/uploads/images/flutter5786.jpg'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCard(
    String name,
    String description,
    String imgPath,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5, left: 5, right: 5),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 5,
                )
              ],
              color: Colors.white),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(imgPath), fit: BoxFit.contain)),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF575E67),
                  fontFamily: 'Varela',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  color: const Color(0xFFEBEBEB),
                  height: 1,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF575E67),
                  fontFamily: 'Varela',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
