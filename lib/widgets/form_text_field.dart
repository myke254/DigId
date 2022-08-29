
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormTextField extends StatelessWidget {
  final Widget prefixIcon;
  final Widget suffixIcon;
  final TextEditingController controller;
  final GlobalKey<FormState>? formKey;
  final String hintText;
  final FocusNode? focusNode;
  final TextInputType inputType;
  final bool obscured;
  final double letterSpacing;
  final bool Function(String)? validator;
  final String errorMessage;
  const FormTextField({
    Key? key,
    this.prefixIcon = const SizedBox(),
    this.suffixIcon = const SizedBox(),
    required this.controller,
    this.formKey,
    this.hintText = "",
    this.focusNode,
    this.letterSpacing = 1.0,
    this.inputType = TextInputType.text,
    this.obscured = false,
    this.validator,
    this.errorMessage="something's missing"
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 10),
      child: TextFormField(
        validator: (value) {
          if (validator!(value!)) return errorMessage;
          
          return null;
        },
        controller: controller,
        style: GoogleFonts.varelaRound(
            color: Theme.of(context).brightness == Brightness.dark?Colors.white:Color(
              0xff8c261e,
            ),
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: letterSpacing),
        keyboardType: inputType,
        obscureText: obscured,
        obscuringCharacter: "*",
        decoration: InputDecoration(
          prefixIcon: prefixIcon.toString() == const SizedBox().toString()
              ? null
              : prefixIcon,
          hintText: hintText,
          suffixIcon: suffixIcon.toString() == const SizedBox().toString()
              ? null
              : suffixIcon,
          enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 1, color:Theme.of(context).brightness == Brightness.dark?Colors.white: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 1, color: Color(0xff8c261e)),
          ),
          errorBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(width: 1, color: Color.fromARGB(255, 255, 0, 0)),
          ),
        ),
      ),
    );
  }
}
