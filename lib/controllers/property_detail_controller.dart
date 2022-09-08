import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/app_user.dart';
import '../services/app_user_service.dart';
import '../widgets/app_dialog/app_dialog.dart';

class PropertyDetailController extends ChangeNotifier with AppDialogWidget {
  PropertyDetailController._internal();

  static final _propertyDetailController = PropertyDetailController._internal();
  static PropertyDetailController get instance => _propertyDetailController;
  final AppUserService _appUserService = AppUserService.instance;

  AppUser? propertyAppUser;
  Future loadPropertyAppUserByUid(String uid) async {
    propertyAppUser = await _appUserService.getAppUserById(uid);
    notifyListeners();
  }

  Map<String, String> getPropertyUtilities(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return {
      'wifi': al.wifi,
      'parking': al.parking,
      'wc': al.wc,
      'detached': al.detached,
      'freedom': al.freedom,
      'freezer': al.freezer,
      'bedroom': al.bedrooms,
      'bathroom': al.bathrooms,
      'hotWaterHeater': al.hotWaterHeater,
      'airConditioned': al.airConditioned,
      'washingMachine': al.washingMachine,
      'garret': al.garret,
      'cabinet': al.cabinet,
      'tv': al.tv,
      'guard': al.guard,
      'balcony': al.balcony,
      'window': al.window,
      'pet': al.pet,
    };
  }

  Map<int, String> getPropertyType(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return {
      0: al.motel,
      1: al.dorm,
      2: al.apartment,
      3: al.house,
    };
  }
}
