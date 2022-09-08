// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  AppController._internal();

  static final _appController = AppController._internal();
  static AppController get instance => _appController;

  bool _isAppBusy = false;
  bool get isAppBusy => _isAppBusy;
  set isAppBusy(value) {
    _isAppBusy = value;
    notifyListeners();
  }
}
