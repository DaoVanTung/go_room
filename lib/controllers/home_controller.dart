import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/property.dart';
import '../services/property_service.dart';
import '../views/search/results_view.dart';
import 'property_controller.dart';

class HomeController extends ChangeNotifier {
  HomeController._internal() {
    getProvince();
    loadNewproperties();
  }

  static final _homeController = HomeController._internal();
  static HomeController get instance => _homeController;
  final PropertyService _propertyService = PropertyService.instance;
  final PropertyController _propertyController = PropertyController.instance;
  List<Property> motelProperties = [];
  List<Property> dormProperties = [];
  List<Property> apartmentProperties = [];
  List<Property> houseProperties = [];

  bool _isBusy = false;
  bool get isBusy => _isBusy;
  set isBusy(value) {
    _isBusy = value;
    notifyListeners();
  }

  void loadNewproperties() async {
    isBusy = true;
    motelProperties = await _propertyService.getNewProperties(
      propertyType: 0,
      provinceCode: _currentProvinceCode ?? 1,
    );
    dormProperties = await _propertyService.getNewProperties(
      propertyType: 1,
      provinceCode: _currentProvinceCode ?? 1,
    );
    apartmentProperties = await _propertyService.getNewProperties(
      propertyType: 2,
      provinceCode: _currentProvinceCode ?? 1,
    );
    houseProperties = await _propertyService.getNewProperties(
      propertyType: 3,
      provinceCode: _currentProvinceCode ?? 1,
    );

    isBusy = false;
    notifyListeners();
  }

  Map<int, Province> _provinces = {};
  Map<int, Province> get provinces => _provinces;
  int? _currentProvinceCode;
  int? get currentProvinceCode => _currentProvinceCode;

  set currentProvinceCode(int? value) {
    if (_currentProvinceCode == value) return;
    _currentProvinceCode = value;
    loadNewproperties();
    notifyListeners();
  }

  void getProvince() async {
    await _propertyController.getProvince();
    _provinces = _propertyController.provinces;
    _currentProvinceCode = 1;
    notifyListeners();
  }

  Future onSeeMoreDormPressed(BuildContext context) async {
    final al = AppLocalizations.of(context)!;

    await _propertyService
        .getNewPropertiesNoLimit(
      propertyType: 1,
      provinceCode: _currentProvinceCode!,
    )
        .then((items) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultView(
            title: '${al.dorm} - ${_provinces[_currentProvinceCode]!.name}',
            items: items,
          ),
        ),
      );
    });
  }

  Future onSeeMoreApartmentPressed(BuildContext context) async {
    final al = AppLocalizations.of(context)!;

    await _propertyService
        .getNewPropertiesNoLimit(
      propertyType: 2,
      provinceCode: _currentProvinceCode!,
    )
        .then((items) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultView(
            title:
                '${al.apartment} - ${_provinces[_currentProvinceCode]!.name}',
            items: items,
          ),
        ),
      );
    });
  }

  Future onSeeMoreMotelPressed(BuildContext context) async {
    final al = AppLocalizations.of(context)!;

    await _propertyService
        .getNewPropertiesNoLimit(
      propertyType: 0,
      provinceCode: _currentProvinceCode!,
    )
        .then((items) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultView(
            title: '${al.motel} - ${_provinces[_currentProvinceCode]!.name}',
            items: items,
          ),
        ),
      );
    });
  }

  Future onSeeMoreHousePressed(BuildContext context) async {
    final al = AppLocalizations.of(context)!;

    await _propertyService
        .getNewPropertiesNoLimit(
      propertyType: 3,
      provinceCode: _currentProvinceCode!,
    )
        .then((items) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultView(
            title: '${al.house} - ${_provinces[_currentProvinceCode]!.name}',
            items: items,
          ),
        ),
      );
    });
  }
}
