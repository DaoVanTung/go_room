import 'package:flutter/material.dart';

class MyTextStyle {
  MyTextStyle._internal();

  static final _instance = MyTextStyle._internal();
  static MyTextStyle get instance => _instance;

  TextStyle get headline {
    return const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get headline1 {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get body {
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
    );
  }

  TextStyle get bodyBold {
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get bodyMediumBold {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get bodyMedium {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );
  }

  TextStyle get bodyLarge {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
    );
  }

  TextStyle get bodyLargeBold {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get subTitle {
    return const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.normal,
    );
  }
}
