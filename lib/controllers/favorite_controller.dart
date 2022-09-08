import 'package:flutter/material.dart';

import '../models/property.dart';
import 'app_user_controller.dart';
import 'property_controller.dart';

class FavoriteController extends ChangeNotifier {
  FavoriteController._internal();

  static final _favoriteController = FavoriteController._internal();
  static FavoriteController get instance => _favoriteController;
  final AppUserController _appUserController = AppUserController.instance;
  final PropertyController _propertyController = PropertyController.instance;

  bool _isBusy = false;
  bool get isBusy => _isBusy;
  set isBusy(value) {
    _isBusy = value;
    notifyListeners();
  }

  List<Property> _savedProperties = [];
  List<Property> get savedProperties => _savedProperties;

  Future loadSavedProperties() async {
    _savedProperties = [];
    isBusy = true;
    final currrentAppUser = _appUserController.currentAppUser;
    if (currrentAppUser == null) {
      isBusy = false;
      return;
    }

    if (currrentAppUser.savedProperties == null) {
      isBusy = false;
      return;
    }

    if (currrentAppUser.savedProperties!.isEmpty) {
      isBusy = false;
      return;
    } else {
      for (var element in currrentAppUser.savedProperties!) {
        final item = await _propertyController.getPropertyByUid(element);
        if (item != null) {
          if (savedProperties.contains(item) == false) {
            savedProperties.add(item);
          }
        }
      }

      isBusy = false;
    }
  }

  Future removeSavedItem(Property property) async {
    if (_savedProperties.contains(property)) {
      _savedProperties.remove(property);
      notifyListeners();
    }
  }
}
