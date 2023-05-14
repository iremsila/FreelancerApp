import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart' as mysql;

class UploadJobNow extends StatefulWidget {
  @override
  _UploadJobNow createState() => _UploadJobNow();
}

class _UploadJobNow extends State<UploadJobNow> {
  final _formKey = GlobalKey<FormState>();

  late String _jobTitle;
  late String _category;
  late String _location;
  late String _description;
  late DateTime _selectedDate;
  late String _budget;
  late String selectedOption = '';
  // MySQL bağlantı ayarları
  String? selectedCountry;

  final List<String> countries = [
    'Country 1',
    'Country 2',
    'Country 3',
    'Country 4',
  ];

  final settings = mysql.ConnectionSettings(
    host: '213.238.183.81',
    port: 3306,
    user: 'httpdegm_melike',
    password: 'A}c74e&QAI[x',
    db: 'httpdegm_database1',
  );
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

//ARKADAŞLAR BURADAKİ BİLGİLER BANA AİT OLDUĞU İÇİN GİTHUB UYARI VERDİ HOST, USER VE PASSWORD KISMINI KENDİNİZE GÖRE DOLDURMANIZ LAZIM.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Post a Job",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "You must fill in all fields correctly.",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Job Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter job title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _jobTitle = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a category';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _category = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Job Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter job description';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _description = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ListTile(
                    title: const Text('Remote'),
                    leading: Radio(
                      value: 'remote',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value as String;
                          selectedCountry = null;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('In-person'),
                    leading: Radio(
                      value: 'in-person',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value as String;
                        });
                      },
                    ),
                  ),
                  if (selectedOption == 'in-person')
                    DropdownButton<String>(
                      value: selectedCountry,
                      hint: Text('SELECT A COUNTRY'),
                      onChanged: (String? value) {
                        setState(() {
                          selectedCountry = value;
                        });
                      },
                      items: countries.map((String country) {
                        return DropdownMenuItem<String>(
                          value: country,
                          child: Text(country),
                        );
                      }).toList(),
                    ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Budget',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter budget';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _budget = value!;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Date in format dd-mm-yy',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter date';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _selectedDate = DateFormat('dd-MM-yyyy').parseUTC(value!);
                    },
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // MySQL bağlantısı
                        final conn =
                            await mysql.MySqlConnection.connect(settings);

                        // Kayıt ekleme
                        await conn.query(
                            '''INSERT INTO upload_job (job_title, category, location, description, budget, date_posted) VALUES (?, ?, ?, ?, ?, ?)''',
                            [
                              _jobTitle,
                              _category,
                              _location,
                              _description,
                              _budget,
                              _selectedDate
                            ]);
                        await conn.close();

                        // Başarılı bildirimi
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Job posted successfully'),
                          ),
                        );
                      }
                    },
                    child: Text('Post Job'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
