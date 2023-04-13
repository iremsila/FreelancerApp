import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper/proivder.dart';
import '../../helper/validators.dart';
import '../../shared/items/popup.dart';
import '../../shared/items/widgets.dart';
import '../../shared/resources/colors.dart';
import '../../shared/resources/fields.dart';
import '../../shared/resources/styles.dart';
import '../../utils/constants.dart';
import '../../utils/expanded.dart';
import '../../utils/methods.dart';
import '../login/login.dart';

class Detais extends StatefulWidget {
  const Detais({super.key});

  @override
  State<Detais> createState() => _DetaisState();
}

class _DetaisState extends State<Detais> {
  late String _password;
  double _strength = 0;
  String _displayText = 'Please enter a password';
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");
  bool check = false;
  bool showCustom = false;
  String countryCode = '+20';
  dynamic countryIndex;
  String countrySt = 'Country';
  String area = 'Area';
  bool showLink = false;
  bool showTermsValidate = false;


  void _checkPassword(String value) {
    _password = value.trim();
    if (_password.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = 'Please enter your password';
      });
    } else if (_password.length < 8) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'Password is too short';
      });
    } else if (!_password.contains(RegExp(r'[A-Z]'))) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Password should contain uppercase letters';
      });
    } else if (!_password.contains(RegExp(r'[a-z]'))) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Password should contain lowercase letters';
      });
    } else if (!_password.contains(RegExp(r'[0-9]'))) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Password should contain numbers';
      });
    } else if (!_password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Password should contain special characters';
      });
    } else {
      setState(() {
        _strength = 1.0;
        _displayText = 'Password is strong';
      });
    }
  }



  String link = '';
  TextEditingController linkController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<AppProvider>(context);
    List areaList =
    countryIndex == null ? [] : country[countryIndex]['locations'] as List;
    return Form(
      key: key,
      child: Column(
        children: [
          //fields
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Name and Surname',
              border: OutlineInputBorder(
              ),prefixIcon: const Icon(
              Icons.person,
              size: 20,
              color: AppColors.primary,
            ),
            ),
            validator: (name) {
              return AppValidator.requiredField(name ?? '');
            },
            onChanged: (char) {
              key.currentState!.validate();
            },
          ),
          freev(),
          TextFormField(
            decoration: const InputDecoration(
            hintText: 'Email Address',
              border: OutlineInputBorder(
              ),
            prefixIcon: const Icon(
              Icons.mail,
              size: 20,
              color: AppColors.primary,
            ),),
            validator: (email) {
              return AppValidator.requiredField(email ?? '');
            },
          ),
          freev(),
          TextField(
            onChanged: (value) => _checkPassword(value),
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Password',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.teal),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.teal),
              ),),
          ),LinearProgressIndicator(
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
          ),Text(
            _displayText,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () {},
              child: const Text('Continue')),
    freev(),
          //custom fields
          prov.current == 0
              ? ExpandedSection(
              expand: showCustom,
              child: SizedBox(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: AppTextFields(
                              readOnly: true,
                              hint: countryCode,
                              suffixIcon: AppPopUpMenu(
                                  list: countryCodes,
                                  txt: 'code',
                                  onSelect: ((value) {
                                    setState(() {
                                      countryCode = countryCodes[value as int]
                                      ['code'] as String;
                                    });
                                  })),
                            )),
                        freeh(h: 15),
                        const Expanded(
                            flex: 2,
                            child: AppTextFields(
                              hint: 'Phone Number',
                              keyboardType: TextInputType.number,
                            )),
                      ],
                    ),
                    freev(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: AppTextFields(
                              readOnly: true,
                              hint: countrySt,
                              suffixIcon: AppPopUpMenu(
                                list: country,
                                txt: 'code',
                                onSelect: (val) {
                                  setState(() {
                                    countrySt =
                                    country[val as int]['code'] as String;
                                    countryIndex = val;
                                  });
                                },
                              ),
                            )),
                        freeh(),
                        Expanded(
                            child: AppTextFields(
                              hint: area,
                              readOnly: true,
                              suffixIcon: AppPopUpMenu(
                                list: countryIndex == null
                                    ? []
                                    : country[countryIndex]['locations']
                                as List,
                                txt: 'loc',
                                onSelect: (val) {
                                  setState(() {
                                    area =
                                    areaList[val as int]['loc'] as String;
                                  });
                                },
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ))
              : prov.current == 1
              ? ExpandedSection(
            expand: showCustom,
            child: SizedBox(
              child: Column(
                children: [
                  AppTextFields(
                    controller: linkController,
                    hint: 'add link',
                    keyboardType: TextInputType.url,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if (linkController.text.isNotEmpty) {
                              showLink = true;
                              link = linkController.text;
                              linkController.text = '';
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.primary,
                          size: 20,
                        )),
                  ),
                  freev(),
                  ExpandedSection(
                    expand: showLink,
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 5),
                      color: AppColors.second,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            link,
                            style: AppStyles.links(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          freeh(h: 8),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  link = '';
                                  showLink = false;
                                });
                              },
                              icon: Text(
                                'X',
                                style: AppStyles.regular(),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
              : const SizedBox(),

          freev(),

          //terms&conditions
          Row(
            children: [
              Checkbox(
                  value: check,
                  checkColor: AppColors.white,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() {
                      if (check == false || showTermsValidate == false) {
                        check = true;
                        showTermsValidate = true;
                      }
                    });
                  }),
              freeh(h: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                          text: 'I agree ',
                          style: AppStyles.light(),
                          children: [
                            TextSpan(
                                text: 'Terms & Conditions',
                                style: AppStyles.light(color: AppColors.primary))
                          ])),
                  showTermsValidate == true
                      ? Text(
                    'you must agree!',
                    style: AppStyles.light(color: Colors.red),
                  )
                      : const SizedBox(),
                ],
              ),
            ],
          ),

          //button
          buttons(
              text: 'Register',
              color: AppColors.primary,
              onTap: () {
                if (key.currentState!.validate()) {
                  if (check == true) {
                    //go to Home Page
                    navigatePush(context, secondPage: const Login());
                  } else {
                    setState(() {
                      showTermsValidate = true;
                    });
                  }
                }
              }),

          //custom button
          showCustom == true
              ? const SizedBox()
              : GestureDetector(
            onTap: () {
              setState(() {
                showCustom = true;
              });
            },
            child: Column(
              children: [
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                ),
                Text(
                  'custom',
                  style: AppStyles.light(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}