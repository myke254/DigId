
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/verify_otp.dart';

class OtpFormField extends StatefulWidget {
  final Function? onChanged;
  final int index;
  const OtpFormField({Key? key, this.onChanged, required this.index})
      : super(key: key);

  @override
  State<OtpFormField> createState() => _OtpFormFieldState();
}

class _OtpFormFieldState extends State<OtpFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 55,
      child: TextField(
        onChanged: (value) {
          // if (widget.index ==0) {
          //   code.value = value;
          // }else {
          //   code = ValueNotifier(code.value+=value);
          // }
          code.value = code.value.substring(0, widget.index);
          code = ValueNotifier(code.value += value);
          value.length == 1 ? FocusScope.of(context).nextFocus() : null;
          print(code.value);
        },
        keyboardType: TextInputType.phone,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        textAlign: TextAlign.center,
        
        style: GoogleFonts.varelaRound(
            fontWeight: FontWeight.bold,
            fontSize: 21,
            color: Color(0xff8c261e)),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 2, color:Theme.of(context).brightness ==Brightness.dark?Colors.white: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 2, color: Color(0xff8c261e)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Color.fromARGB(255, 255, 0, 0)),
          ),
        ),
      ),
    );
  }
}
