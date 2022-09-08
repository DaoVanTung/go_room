// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/app_dialog/app_dialog.dart';
import 'app_user_controller.dart';

class UpdateProfileController extends ChangeNotifier with AppDialogWidget {
  UpdateProfileController._internal();

  static final _updateProfileController = UpdateProfileController._internal();
  static UpdateProfileController get instance => _updateProfileController;
  final AppUserController _appUserController = AppUserController.instance;

  bool _isBusy = false;
  bool get isBusy => _isBusy;
  set isBusy(value) {
    _isBusy = value;
    notifyListeners();
  }

  final displayNameKey = GlobalKey<FormFieldState>();
  final phoneNumberKey = GlobalKey<FormFieldState>();
  final emailKey = GlobalKey<FormFieldState>();

  /// The user selects a file, and the task is added to the list.
  Future<String?> uploadFile({XFile? xfile}) async {
    if (xfile == null) {
      return null;
    }

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('avatar')
        .child(_appUserController.currentAppUser!.uid!)
        .child('/${DateTime.now().millisecondsSinceEpoch}_${xfile.name}');

    await ref.putFile(File(xfile.path));

    final link = await ref.getDownloadURL();

    return link;
  }

  Future onAvatarPressed() async {
    final imagePicker = ImagePicker();

    final image = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      final link = await uploadFile(xfile: image);

      _appUserController.currentAppUser!.photoURL = link;
      _appUserController.saveAppUser(_appUserController.currentAppUser!);
    }

    notifyListeners();
  }

  Future onSaveButtonPressed(BuildContext context) async {
    if (displayNameKey.currentState!.validate()) {
      if (phoneNumberKey.currentState!.validate()) {
        if (emailKey.currentState!.validate()) {
          final currentAppUser = _appUserController.currentAppUser;
          if (currentAppUser != null) {
            isBusy = true;

            currentAppUser.displayName = displayNameKey.currentState!.value;
            currentAppUser.phoneNumber = phoneNumberKey.currentState!.value;
            currentAppUser.email = emailKey.currentState!.value;
            await _appUserController.saveAppUser(currentAppUser);

            isBusy = false;
            notifyListeners();
          }
        }
      }
    }
  }
}
