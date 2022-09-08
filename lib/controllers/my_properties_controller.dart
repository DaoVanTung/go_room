import 'package:flutter/material.dart';

import '../models/property.dart';
import 'app_user_controller.dart';
import 'property_controller.dart';

class MyPropertiesController extends ChangeNotifier {
  MyPropertiesController._internal();

  static final _myPropertiesController = MyPropertiesController._internal();
  static MyPropertiesController get instance => _myPropertiesController;

  final AppUserController _appUserController = AppUserController.instance;
  final PropertyController _propertyController = PropertyController.instance;

  bool _isBusy = false;
  bool get isBusy => _isBusy;
  set isBusy(value) {
    _isBusy = value;
    notifyListeners();
  }

  List<Property> _waitingProperties = [];
  List<Property> get waitingProperties => _waitingProperties;

  List<Property> _showingProperties = [];
  List<Property> get showingProperties => _showingProperties;

  List<Property> _hiddenProperties = [];
  List<Property> get hiddenProperties => _hiddenProperties;

  Future loadMyProperties() async {
    _waitingProperties = [];
    _showingProperties = [];
    _hiddenProperties = [];

    isBusy = true;
    final currrentAppUser = _appUserController.currentAppUser;

    if (currrentAppUser == null) {
      isBusy = false;
      return;
    }

    if (currrentAppUser.properties == null) {
      isBusy = false;
      return;
    }

    if (currrentAppUser.properties!.isEmpty) {
      isBusy = false;
      return;
    } else {
      for (var element in currrentAppUser.properties!) {
        final item = await _propertyController.getPropertyByUid(element);

        if (item != null) {
          if (item.status == 0) {
            _waitingProperties.add(item);
          } else if (item.status == 1) {
            _showingProperties.add(item);
          } else if (item.status == 2) {
            _hiddenProperties.add(item);
          }
        }
      }

      isBusy = false;
      notifyListeners();
    }
  }

  Future hideProperty(Property property) async {
    property.status = 2;
    await _propertyController.saveProperty(property);
    notifyListeners();
  }

  Future showProperty(Property property) async {
    property.status = 1;
    await _propertyController.saveProperty(property);
    notifyListeners();
  }

  Future deleteProperty(String propertyId) async {
    await _propertyController.deleteProperty(propertyId);
    notifyListeners();
  }
}
