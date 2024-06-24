import 'package:flutter/material.dart';

class AppConstant {
  static const trlocale = Locale("tr", "TR");
  static const enlocale= Locale("en", "US");
  static const langPath = "assets/language";

  static const supportedLocale = [
    AppConstant.enlocale,
    AppConstant.trlocale
  ];
}