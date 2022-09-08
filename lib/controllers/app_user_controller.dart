// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/app_user.dart';
import '../services/app_user_service.dart';
import '../services/auth_service.dart';
import '../widgets/app_dialog/app_dialog.dart';

class AppUserController extends ChangeNotifier with AppDialogWidget {
  AppUserController._internal() {
    _init();
  }

  static final _appUserController = AppUserController._internal();
  static AppUserController get instance => _appUserController;

  final AppUserService _appUserService = AppUserService.instance;

  _init() async {
    final user = AuthService.instance.currentUser;
    if (user == null) return;
    currentAppUser = await getAppUserByUid(user.uid);
  }

  AppUser? _currentAppUser;
  AppUser? get currentAppUser => _currentAppUser;

  set currentAppUser(AppUser? value) {
    _currentAppUser = value;
    notifyListeners();
  }

  Future<AppUser?> getAppUserByUid(String uid) async {
    AppUser? appUser = await _appUserService.getAppUserById(uid);
    return appUser;
  }

  Future saveAppUser(AppUser appUser) async {
    await _appUserService.saveAppUser(appUser);
  }

  AppUser getAppUserFromFirebaseUser(User user) {
    final appUser = AppUser(
      uid: user.uid,
      displayName: user.displayName ?? 'Aurazi User',
      email: user.email,
      creationTime: user.metadata.creationTime,
      lastSignInTime: user.metadata.lastSignInTime,
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL,
    );

    return appUser;
  }

  void addOrRemovePropertyToFavorite(
    BuildContext context, {
    required String propertyId,
  }) {
    if (currentAppUser == null) {
      final al = AppLocalizations.of(context)!;

      final snackBar = SnackBar(
        content: Text(al.needLoginToUse),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      _currentAppUser!.savedProperties ??= [];
      if (_currentAppUser!.savedProperties!.contains(propertyId)) {
        _currentAppUser!.savedProperties!.remove(propertyId);
      } else {
        _currentAppUser!.savedProperties!.add(propertyId);
      }

      _appUserService.saveAppUser(currentAppUser!);
      notifyListeners();
    }
  }

  bool isSavedProperty(String propertyId) {
    if (currentAppUser == null) {
      return false;
    } else {
      _currentAppUser!.savedProperties ??= [];
      if (_currentAppUser!.savedProperties!.contains(propertyId)) {
        return true;
      } else {
        return false;
      }
    }
  }
}
