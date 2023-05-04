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

  // MySQL bağlantı ayarları

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
      body: Padding(
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
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter location';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _location = value!;
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
                // ElevatedButton(
                //   onPressed: () async {
                //     final DateTime? selectedDate = await _selectedDate;
                //     if (selectedDate != null) {
                //       setState(() {
                //         _selectedDate = selectedDate;
                //       });
                //     }
                //   },
                //   child: Text(
                //       'Select Date: ${DateFormat.yMd().format(_selectedDate)}'),
                // ),
                SizedBox(height: 10.0),
                //SizedBox(height: 16.0),
                // ElevatedButton(
                //   onPressed: () async {
                //     final DateTime? picked = await _selectDate(context);
                //     if (picked != null) {
                //       // Seçilen tarihi kullan
                //     }
                //   },
                //   child: Text('Select Date'),
                // ),
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
    );
  }
}