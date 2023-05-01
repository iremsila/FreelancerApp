import 'package:flutter/material.dart';
import '../../Widget/bottom_nav_bar.dart';
import 'package:mysql1/mysql1.dart' as mysql;

class UploadJobNow extends StatefulWidget {
  @override
  _UploadJobNow createState() => _UploadJobNow();
}

class _UploadJobNow extends State<UploadJobNow> {
  final _formKey = GlobalKey<FormState>();

  late String _jobTitle;
  late String _companyName;
  late String _location;
  late String _description;

  // MySQL bağlantı ayarları
  final settings = mysql.ConnectionSettings(
    host: 'ip',
    port: 3306,
    user: 'user_name',
    password: 'user_password',
    db: 'httpdegm_database1',
  );
//ARKADAŞLAR BURADAKİ BİLGİLER BANA AİT OLDUĞU İÇİN GİTHUB UYARI VERDİ HOST, USER VE PASSWORD KISMINI KENDİNİZE GÖRE DOLDURMANIZ LAZIM.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1),
      appBar: AppBar(
        title: Text('Post a Job'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    labelText: 'Company Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _companyName = value!;
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
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // MySQL bağlantısı
                      final conn =
                          await mysql.MySqlConnection.connect(settings);

                      // Kayıt ekleme
                      await conn.query(
                          '''INSERT INTO jobs (job_title, company_name, location, description) VALUES (?, ?, ?, ?)''',
                          [_jobTitle, _companyName, _location, _description]);
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
