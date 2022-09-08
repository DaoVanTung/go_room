import 'package:flutter/material.dart';

import '../models/property.dart';

class ResultController extends ChangeNotifier {
  ResultController._internal();

  static final ResultController _instance = ResultController._internal();
  static ResultController get instance => _instance;

  bool _isBusy = false;
  bool get isBusy => _isBusy;
  set isBusy(value) {
    _isBusy = value;
    notifyListeners();
  }

  final Map<String, Property> currentProperties = {};
  void getProperties() async {
    isBusy = true;
    // await _propertyService.getNewProperties(
    //   propertyType: 0,
    //   provinceCode: _currentProvinceCode ?? 1,
    // );

    isBusy = false;
    notifyListeners();
  }
}
