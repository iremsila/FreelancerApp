
import 'package:flutter/material.dart';

class AppTextFields extends StatefulWidget {
  const AppTextFields({
    super.key,
    this.controller,
    this.keyboardType,
    this.obscure = false,
    this.validator,
    required this.hint,
    this.fillColor,
    this.filled,
    this.suffixIcon,
    this.onChanged,
    this.readOnly = false,
    this.prefixIcon,
    this.maxLines = 1,
  });
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscure;
  final String? Function(String?)? validator;
  final String hint;
  final Color? fillColor;
  final Function(String)? onChanged;
  final bool? filled;
  final int maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  @override
  State<AppTextFields> createState() => _AppTextFieldsState();
}

class _AppTextFieldsState extends State<AppTextFields> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscure,
      readOnly: widget.readOnly,
      validator: widget.validator,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        filled: widget.filled,
        fillColor: widget.fillColor,
        border: underlineInputBorder(), //grey
        errorBorder: underlineInputBorder(color: Colors.red), //red
        focusedBorder: underlineInputBorder(color: Colors.white), //primary
      ),
    );
  }
}

UnderlineInputBorder underlineInputBorder({Color color = Colors.grey}) {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: color,
      width: 1.5,
    ),
  );
}

class AppPassFields extends StatefulWidget {
  const AppPassFields(
      {super.key,
        this.InputBorder ,
        this.filled,
        this.prefixIcon,
        this.fillColor,
        this.onChanged,
        this.validator});
  final Widget? InputBorder ;
  final bool? filled;
  final Color? fillColor;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  @override
  State<AppPassFields> createState() => _AppPassFieldsState();
}

class _AppPassFieldsState extends State<AppPassFields> {
  bool secure = true;
  @override
  Widget build(BuildContext context) {
    return AppTextFields(
      hint: 'Password',
      validator: widget.validator,
      obscure: secure,
      onChanged: widget.onChanged,
      prefixIcon: widget.prefixIcon,
      suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              secure = !secure;
            });
          },
          icon: Icon(Icons.remove_red_eye_rounded,
              color: secure == false ? Colors.green : Colors.white)),
      fillColor: widget.fillColor,
      filled: widget.filled,
    );
  }
}