import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:intl/intl.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadJobNow extends StatefulWidget {
  @override
  _UploadJobNow createState() => _UploadJobNow();
}

class _UploadJobNow extends State<UploadJobNow> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate; // Nullable olarak güncellendi
  String? selectedCountry; // Seçilen ülke
  MySqlConnection? conn;

  TextEditingController jobTitleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  late String selectedOption = '';

  final List<String> countries = [
    'China',
    'England',
    'France',
    'Germany',
    'Greece',
    'India',
    'Japan',
    'Russia',
    'Spain',
    'The U.S.A',
    'Türkiye',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
      });
    }
  }

  Future<void> _postToDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    var settings = new ConnectionSettings(
      host: '213.238.183.81',
      port: 3306,
      user: 'httpdegm_hudai',
      password: ',sPE[gd^hbl1',
      db: 'httpdegm_database1',
    );

    conn = await MySqlConnection.connect(settings);

    String jobTitle = jobTitleController.text;
    String category = categoryController.text;
    String jobDescription = jobDescriptionController.text;
    String? country = selectedOption == 'remote' ? 'Remote' : selectedCountry;
    String budget = budgetController.text;
    String date = DateFormat('yyyy-MM-dd').format(selectedDate!);

    await conn!.query(
      'INSERT INTO upload_job1 (user_id, job_title, category, location, description, budget, date_posted) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [userId, jobTitle, category, country, jobDescription, budget, date],
    );

    // Veritabanı bağlantısını kapatın
    await conn!.close();

    jobTitleController.clear();
    categoryController.clear();
    jobDescriptionController.clear();
    budgetController.clear();
    dateController.clear();
    setState(() {
      selectedDate = null;
      selectedCountry = null;
      selectedOption = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Job posted successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post a Job",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                    "Please fill in all fields correctly.",
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
                    controller: jobTitleController,
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
                    controller: categoryController,
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
                    controller: jobDescriptionController,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Select work type",
                    style: TextStyle(fontSize: 16),
                  ),
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
                      hint: Text('Selecet a Country'),
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
                    controller: budgetController,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    readOnly: true,
                    onTap: () {
                      _selectDate(context);
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.calendar_month),
                      labelText: 'Tap to Select Date ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter date';
                      }
                      return null;
                    },
                    controller: dateController,
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          selectedOption.isNotEmpty &&
                          (selectedOption != 'in-person' ||
                              selectedCountry != null)) {
                        _postToDatabase();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Please fill in all fields correctly'),
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
