import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  //One instance, needs factory
  static AppColors? _instance;
  factory AppColors() => _instance ??= AppColors._();

  AppColors._();

  static const boxColor = Color(0xffe5f467);
  static const buttonColorDark = Color(0xff3a62db);
  // Color(0xff86ad3f)
  static const buttonColor = Color(0xFF6a84d4);
  static const appBarColor = Color(0xffd5ec6a);
  static const themeStart = Color(0xFF4169E1);
  static const themeStop = Color(0xFFb394f4);


  //Teal
  // static const themeStart = Color(0xFF008080);
  // static const themeStop = Color(0xFFAFEEEE);
}