import 'package:flutter/material.dart';

import '../models/property.dart';
import '../services/property_service.dart';
import 'app_user_controller.dart';
import 'property_controller.dart';

class ApprovalPropertiesController extends ChangeNotifier {
  ApprovalPropertiesController._internal();

  static final _approvalPropertiesController =
      ApprovalPropertiesController._internal();
  static ApprovalPropertiesController get instance =>
      _approvalPropertiesController;

  final AppUserController _appUserController = AppUserController.instance;
  final PropertyController _propertyController = PropertyController.instance;
  final PropertyService _propertyService = PropertyService.instance;

  bool _isBusy = false;
  bool get isBusy => _isBusy;
  set isBusy(value) {
    _isBusy = value;
    notifyListeners();
  }

  List<Property> _waitingProperties = [];
  List<Property> get waitingProperties => _waitingProperties;

  Future loadProperties() async {
    _waitingProperties = [];

    isBusy = true;
    final currrentAppUser = _appUserController.currentAppUser;

    if (currrentAppUser == null) {
      isBusy = false;
      return;
    }

    if (currrentAppUser.role == null || currrentAppUser.role == 0) {
      isBusy = false;
      return;
    }

    _waitingProperties = await _propertyService.loadTotalWaitingProperty();

    isBusy = false;
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
