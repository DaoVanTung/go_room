import 'package:flutter/material.dart';
import 'package:go_room/models/app_user.dart';

import '../services/app_user_service.dart';

class RoleAssignmentController extends ChangeNotifier {
  RoleAssignmentController._internal();

  static final RoleAssignmentController _instance =
      RoleAssignmentController._internal();
  static RoleAssignmentController get instance => _instance;
  final AppUserService _appUserService = AppUserService.instance;

  List<AppUser> _appUserList = [];
  List<AppUser> get appUserList => _appUserList;

  Future loadAllAppUser() async {
    _appUserList = await _appUserService.loadAllAppUser();
    _appUserList.removeWhere((item) => item.role == 2);
    notifyListeners();
  }

  Future setAppUserAsCensor(int index, AppUser appUser) async {
    appUser.role = 1;
    await _appUserService.saveAppUser(appUser);
    _appUserList[index] = appUser;
    notifyListeners();
  }

  Future setAppUserAsDefaultUser(int index, AppUser appUser) async {
    appUser.role = 0;
    await _appUserService.saveAppUser(appUser);
    _appUserList[index] = appUser;
    notifyListeners();
  }
}
