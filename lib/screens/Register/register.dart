import 'package:FreelancerApp/screens/login/login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  String? dropdownValue = "Choose!";
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _NameController = TextEditingController();
  final _ageController = TextEditingController();
  late AnimationController _animatedController;
  late Animation<double> _animation;

  bool _isVisible = false;

  void updateStatus() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  late String _password;
  double _strength = 0;

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");
  String _displayText = ' ';

  void _checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = '  ';
      });
    } else if (_password.length < 6) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'Your password is too short';
      });
    } else if (_password.length < 8) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Your password is acceptable but not strong';
      });
    } else {
      if (!letterReg.hasMatch(_password) || !numReg.hasMatch(_password)) {
        setState(() {
          // Password length >= 8
          // But doesn't contain both letter and digit characters
          _strength = 3 / 4;
          _displayText = 'Your password is strong';
        });
      } else {
        // Password length >= 8
        // Password contains both letter and digit characters
        setState(() {
          _strength = 1;
          _displayText = 'Your password is great';
        });
      }
    }
  }

  Future signUp() async {}

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  bool _obsecuredText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _NameController.dispose();
    _ageController.dispose();
    _animatedController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animatedController =
        AnimationController(vsync: this, duration: Duration(seconds: 50));
    _animation =
        CurvedAnimation(parent: _animatedController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animatedController.reset();
              _animatedController.forward();
            }
          });
    _animatedController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://i.pinimg.com/564x/81/db/9f/81db9f703de0ec7e79919174623f3d9e.jpg",
            errorWidget: (context, url, error) => Icon(Icons.error),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 12),
                    Text(
                      "Hello There! ",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent[700]),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        controller: _NameController,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Name and Surname",
                          hintStyle: TextStyle(color: Colors.redAccent[700]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _ageController,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Age",
                          hintStyle: TextStyle(color: Colors.redAccent[700]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.redAccent[700]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        onChanged: (value) => _checkPassword(value),
                        obscureText: _isVisible ? false : true,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                        ],
                        validator: (value) {
                          if (value!.isEmpty || value.length < 8) {
                            return 'Please Enter a valid password';
                          }
                        },
                        controller: _passwordController,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.redAccent[700]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          suffixIcon: IconButton(
                            color: Colors.blueGrey,
                            onPressed: () => updateStatus(),
                            icon: Icon(_isVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        obscureText: _isVisible ? false : true,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                        ],
                        validator: (value) {
                          if (value!.isEmpty || value.length < 8) {
                            return 'Please Enter a valid password';
                          }
                        },
                        controller: _confirmpasswordController,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Confirmed Password",
                          hintStyle: TextStyle(color: Colors.redAccent[700]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          suffixIcon: IconButton(
                            color: Colors.blueGrey,
                            onPressed: () => updateStatus(),
                            icon: Icon(_isVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: LinearProgressIndicator(
                        value: _strength,
                        backgroundColor: Colors.grey[300],
                        color: _strength <= 1 / 4
                            ? Colors.red
                            : _strength == 2 / 4
                                ? Colors.yellow
                                : _strength == 3 / 4
                                    ? Colors.blue
                                    : Colors.green,
                        minHeight: 15,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    // The message about the strength of the entered password
                    Text(
                      _displayText,
                      style: const TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text("Employer or Freelancer ?",
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        style: const TextStyle(color: Colors.red),
                        items: <String>['Choose!', 'Employer', 'Freelancer']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: signUp,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.redAccent[700],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You have already an",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginPage(
                                      showRegisterPage: () {},
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text("account? ")),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
