// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  TextStyle style = GoogleFonts.varelaRound();
  get darkTheme => ThemeData(
    
      scaffoldBackgroundColor:  Color.fromARGB(255, 0, 0, 0),
       primaryColor: Color(0xff8c261e),
       primarySwatch: Colors.red,
      brightness: Brightness.dark,
      fontFamily: style.fontFamily,
     cardTheme: CardTheme(
       color: Colors.black
     ),
      appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness:Brightness.light,
        statusBarColor: Colors.transparent,
          ),
          titleTextStyle: style,
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0));

  get lightTheme => ThemeData(
    
          scaffoldBackgroundColor: Colors.white,
       primaryColor: Color(0xff8c261e),
       primarySwatch: Colors.brown,
      brightness: Brightness.light,
      fontFamily:style.fontFamily,
    
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness:Brightness.dark,
        statusBarColor: Colors.transparent,
          ),
        titleTextStyle:style.copyWith(color: Colors.black),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0
      ));
}
