import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyStyleConfig {
  MyStyleConfig._internal();

  static final _instance = MyStyleConfig._internal();
  static MyStyleConfig get instance => _instance;

  double get tinyPadding => 2.0;
  double get smallPadding => 4.0;
  double get mediumPadding => 8.0;
  double get defaultPadding => 12.0;
  double get largePadding => 16.0;

  double get smallIconSize => 16.0;
  double get mediumIconSize => 20.0;
  double get defaultIconSize => 24.0;
  double get largeIconSize => 32.0;

  Color get primaryColor => const Color(0xff4030EB);
  Color get secondaryColor => const Color(0xff66D7EE);
  Color get whiteColor => const Color(0xffFFFFFF);
  Color get whiteBlurColor => const Color(0xffF5F5F5);
  Color get backgroundColor => const Color(0xffF8F8F8);
  Color get redColor => const Color(0xffFF003D);

  Color get blackColor => const Color(0xff000000);
  Color get greyColor => const Color(0xffC2C2C2);
  Color get greyBlurColor => const Color(0xffEDEEF1);
  Color get lightGreenColor => const Color(0xff8AE85F);
  Color get yellowColor => const Color(0xffF7CF1D);

  final numberFormat = NumberFormat.currency(
    customPattern: '#,### \u00a4',
    symbol: 'VND',
    decimalDigits: 0,
  );
}
