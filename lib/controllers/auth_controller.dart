// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'app_controller.dart';
import 'app_user_controller.dart';
import '../models/app_user.dart';
import '../widgets/app_dialog/app_dialog.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier with AppDialogWidget {
  AuthController._internal();

  static final _loginController = AuthController._internal();
  static AuthController get instance => _loginController;

  final AuthService _authService = AuthService.instance;
  final AppUserController _appUserController = AppUserController.instance;

  bool _isBusy = false;
  bool get isBusy => _isBusy;
  set isBusy(value) {
    _isBusy = value;
    notifyListeners();
  }

  bool _isShowPasswordSignIn = false;
  bool get isShowPasswordSignIn => _isShowPasswordSignIn;
  set isShowPasswordSignIn(value) {
    _isShowPasswordSignIn = value;
    notifyListeners();
  }

  bool _isShowPasswordSignUp = false;
  bool get isShowPasswordSignUp => _isShowPasswordSignUp;
  set isShowPasswordSignUp(value) {
    _isShowPasswordSignUp = value;
    notifyListeners();
  }

  bool _isShowPasswordChange = false;
  bool get isShowPasswordChange => _isShowPasswordChange;
  set isShowPasswordChange(value) {
    _isShowPasswordChange = value;
    notifyListeners();
  }

  bool _isShowPasswordConfirm = false;
  bool get isShowPasswordConfirm => _isShowPasswordConfirm;
  set isShowPasswordConfirm(value) {
    _isShowPasswordConfirm = value;
    notifyListeners();
  }

  bool get isLogin => _authService.loginStatus();

  String? validateEmail(
    BuildContext context, {
    required String? email,
  }) {
    final al = AppLocalizations.of(context);

    if (email == null || email.isEmpty) {
      return al!.enterEmail;
    } else {
      bool isValid = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
      ).hasMatch(email);

      if (isValid) {
        return null;
      } else {
        return al!.invalidEmail;
      }
    }
  }

  String? validatePassword(
    BuildContext context, {
    required String? password,
  }) {
    final al = AppLocalizations.of(context);

    if (password == null || password.isEmpty) {
      return al!.enterPassword;
    } else {
      bool isValid = password.length >= 8;
      if (isValid) {
        return null;
      } else {
        return al!.invalidPassword;
      }
    }
  }

  String? validatePhoneNumber(
    BuildContext context, {
    required String? phoneNumber,
  }) {
    final al = AppLocalizations.of(context);

    if (phoneNumber == null || phoneNumber.isEmpty) {
      return al!.enterPhoneNumber;
    } else {
      bool isValid = RegExp(
        r'(\+84[3|5|7|8|9]|0[3|5|7|8|9]|84[3|5|7|8|9]|0[3|5|7|8|9])+([0-9]{8})\b',
      ).hasMatch(phoneNumber);

      if (isValid) {
        return null;
      } else {
        return al!.invalidPhoneNumber;
      }
    }
  }

  String? validateFullName(
    BuildContext context, {
    required String? fullName,
  }) {
    final al = AppLocalizations.of(context);

    if (fullName == null || fullName.isEmpty) {
      return al!.enterFullname;
    } else {
      bool isValid = RegExp(
        r'^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s\W|_]+$',
      ).hasMatch(fullName);

      if (isValid) {
        return null;
      } else {
        return al!.invalidFullName;
      }
    }
  }

  Future<void> signInWithEmailAndPassword(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    isBusy = true;
    _authService
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      isBusy = false;

      if (value != null) {
        catchAuthException(
          context,
          errorCode: value,
        );
      } else {
        final user = _authService.currentUser;
        await _appUserController.getAppUserByUid(user!.uid).then((appUser) {
          _appUserController.currentAppUser = appUser;
          _appUserController.saveAppUser(appUser!);

          Navigator.of(context).pop();
        });
      }
    });
  }

  Future<void> signInWithGoogle(
    BuildContext context,
  ) async {
    isBusy = true;
    _authService.signInWithGoogle().then((value) async {
      if (value != null) {
        isBusy = false;

        catchAuthException(
          context,
          errorCode: value,
        );
      } else {
        final user = _authService.currentUser;
        AppUser? appUser = await _appUserController.getAppUserByUid(user!.uid);
        appUser ??= _appUserController.getAppUserFromFirebaseUser(user);
        _appUserController.currentAppUser = appUser;
        _appUserController.saveAppUser(appUser);

        isBusy = false;
      }
    });
  }

  void signUpWithEmailAndPassword(
    BuildContext context, {
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) {
    final al = AppLocalizations.of(context)!;

    isBusy = true;
    _authService
        .signUpWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      if (value != null) {
        isBusy = false;

        catchAuthException(
          context,
          errorCode: value,
        );
      } else {
        final user = _authService.currentUser;
        final appUser = _appUserController.getAppUserFromFirebaseUser(user!);

        appUser.displayName = displayName;
        appUser.phoneNumber = phoneNumber;
        await _appUserController.saveAppUser(appUser).then((value) {
          signOut();
          isBusy = false;

          showSuccessDialog(
            context,
            title: 'Yay!',
            content: al.signUpSuccess,
          );
        });
      }
    });
  }

  Future signOut() async {
    AppController.instance.isAppBusy = true;
    await _authService.signOut();
    AppController.instance.isAppBusy = false;
    notifyListeners();
  }

  Future updatePassword(
    BuildContext context, {
    required String newPassword,
  }) async {
    isBusy = true;
    print(isBusy);
    final al = AppLocalizations.of(context)!;

    _authService.updatePassword(newPassword).then((value) {
      if (value != null) {
        catchAuthException(
          context,
          errorCode: value,
        );
      } else {
        showSuccessDialog(
          context,
          title: 'Yay!',
          content: al.updatePasswordSuccess,
        );
      }
      isBusy = false;
      notifyListeners();
    });
  }

  void catchAuthException(
    BuildContext context, {
    required String errorCode,
  }) {
    final al = AppLocalizations.of(context);

    String content = '';

    switch (errorCode) {
      case 'invalid-email':
        content = al!.invalidEmail;
        break;
      case 'user-disabled':
        content = al!.userDisabled;
        break;
      case 'user-not-found':
        content = al!.userNotFound;
        break;
      case 'wrong-password':
        content = al!.wrongPassword;
        break;
      case 'email-already-in-use':
        content = al!.emailAlreadyInUse;
        break;
      case 'operation-not-allowed':
        content = al!.operationNotAllowed;
        break;
      case 'weak-password':
        content = al!.weakPassword;
        break;
      case 'requires-recent-login':
        content = al!.requiresRecentLogin;
        break;
      case 'notLoggedIn':
        content = al!.requiresRecentLogin;
        break;
      default:
        content = al!.somethingWentWrong;
        break;
    }

    showErrorDialog(
      context,
      title: 'Oops!',
      content: content,
    );
  }
}
