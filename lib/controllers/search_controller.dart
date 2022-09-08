import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../models/property.dart';
import '../services/collection_path.dart';
import '../services/property_service.dart';
import '../views/search/results_view.dart';
import '../widgets/app_dialog/app_dialog.dart';

class SearchController extends ChangeNotifier with AppDialogWidget {
  SearchController._internal();

  static final _searchController = SearchController._internal();
  static SearchController get instance => _searchController;
  final PropertyService _propertyService = PropertyService.instance;

  RangeValues _selectedPriceRange = const RangeValues(
    0,
    2000000,
  );

  RangeValues get selectedPriceRange => _selectedPriceRange;
  set selectedPriceRange(RangeValues newValues) {
    _selectedPriceRange = newValues;
    notifyListeners();
  }

  int _currentPropertyType = 0;
  int get currentPropertyType => _currentPropertyType;
  set currentPropertyType(int value) {
    _currentPropertyType = value;
    notifyListeners();
  }

  List<String> _currentPropertyUtilities = [];
  List<String> get currentPropertyUtilities => _currentPropertyUtilities;
  set currentPropertyUtilities(List<String> value) {
    _currentPropertyUtilities = value;
    notifyListeners();
  }

  void addItemCurrentPropertyUtilities(String value) {
    _currentPropertyUtilities.add(value);
    notifyListeners();
  }

  void removeItemCurrentPropertyUtilities(String value) {
    _currentPropertyUtilities.remove(value);
    notifyListeners();
  }

  Future<Property?> getPropertyByUid(String propertyId) async {
    Property? property = await _propertyService.getPropertyById(
      propertyId,
    );
    return property;
  }

  void saveProperty(Property property) {
    _propertyService.saveProperty(property);
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

  Map<int, String> getNumberOfRoom(BuildContext context) {
    return {
      0: '0',
      1: '1',
      2: '2',
      3: '3',
      4: '4',
      5: '5',
    };
  }

  int? _currentNumberOfBed;
  int? get currentNumberOfBed => _currentNumberOfBed;
  set currentNumberOfBed(int? value) {
    _currentNumberOfBed = value;
    notifyListeners();
  }

  int? _currentNumberOfBath;
  int? get currentNumberOfBath => _currentNumberOfBath;
  set currentNumberOfBath(int? value) {
    _currentNumberOfBath = value;
    notifyListeners();
  }

  Map<int, Province> _provinces = {};
  Map<int, District> _districts = {};
  Map<int, Ward> _wards = {};

  Map<int, Province> get provinces => _provinces;
  Map<int, District> get districts => _districts;
  Map<int, Ward> get wards => _wards;

  int? _currentProvinceCode;
  int? _currentDistrictCode;
  int? _currentWardCode;

  int? get currentProvinceCode => _currentProvinceCode;
  int? get currentDistrictCode => _currentDistrictCode;
  int? get currentWardCode => _currentWardCode;

  set currentProvinceCode(int? value) {
    if (_currentProvinceCode == value) return;
    _currentProvinceCode = value;
    _currentDistrictCode = null;
    _currentWardCode = null;

    _districts = {};
    _wards = {};
    notifyListeners();
  }

  set currentDistrictCode(int? value) {
    if (_currentDistrictCode == value) return;
    _currentDistrictCode = value;
    _currentWardCode = null;
    _wards = {};
    notifyListeners();
  }

  set currentWardCode(int? value) {
    _currentWardCode = value;
    notifyListeners();
  }

  Future getProvince() async {
    var client = http.Client();
    try {
      final uri = Uri.parse('https://provinces.open-api.vn/api/p/');

      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var body = jsonDecode(utf8.decode(response.bodyBytes));
        _provinces = {};
        body.forEach((e) {
          final province = Province(
            code: e['code'],
            name: e['name'],
          );
          provinces.putIfAbsent(province.code, () => province);
        });

        notifyListeners();
      } else {
        // ignore: avoid_print
        print('Request failed with status: ${response.statusCode}.');
      }
    } finally {
      client.close();
    }
  }

  void getDistrictOfProvince() async {
    if (_currentProvinceCode == null) {
      return;
    }
    var client = http.Client();
    try {
      final uri = Uri.parse(
          'https://provinces.open-api.vn/api/p/$_currentProvinceCode/?depth=2');

      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var body = jsonDecode(utf8.decode(response.bodyBytes));
        _districts = {};
        body['districts'].forEach((e) {
          final district = District(
            code: e['code'],
            name: e['name'],
            provinceCode: e['province_code'],
          );
          districts.putIfAbsent(district.code, () => district);
        });

        notifyListeners();
      } else {
        // ignore: avoid_print
        print('Request failed with status: ${response.statusCode}.');
      }
    } finally {
      client.close();
    }
  }

  void getWardOfDistrict() async {
    if (_currentDistrictCode == null) {
      return;
    }
    var client = http.Client();
    try {
      final uri = Uri.parse(
          'https://provinces.open-api.vn/api/d/$_currentDistrictCode/?depth=2');

      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var body = jsonDecode(utf8.decode(response.bodyBytes));
        _wards = {};
        body['wards'].forEach((e) {
          final ward = Ward(
            code: e['code'],
            name: e['name'],
            districtCode: e['district_code'],
          );
          wards.putIfAbsent(ward.code, () => ward);
        });

        notifyListeners();
      } else {
        // ignore: avoid_print
        print('Request failed with status: ${response.statusCode}.');
      }
    } finally {
      client.close();
    }
  }

  final Map<String, GlobalKey<FormFieldState>> _textKeys = {
    'titleKey': GlobalKey<FormFieldState>(),
  };

  GlobalKey<FormFieldState> get titleKey => _textKeys['titleKey']!;

  Future onSearchButtonPressed(BuildContext context) async {
    final db = FirebaseFirestore.instance;
    final doc = db.collection(CollectionPath.property);
    var query = doc.where('type', isEqualTo: _currentPropertyType);
    query = query.where(
      'price',
      isLessThanOrEqualTo: selectedPriceRange.end,
      isGreaterThanOrEqualTo: selectedPriceRange.start,
    );
    if (_currentNumberOfBed != null) {
      query = query.where('numberOfBed', isEqualTo: _currentNumberOfBed);
    }

    if (_currentNumberOfBath != null) {
      query = query.where('numberOfBath', isEqualTo: _currentNumberOfBath);
    }

    if (titleKey.currentState?.value != null) {
      query = query.where('title', arrayContains: titleKey.currentState?.value);
    }

    if (_currentWardCode != null) {
      query = query.where('wardCode', isEqualTo: _currentWardCode);
    } else if (_currentDistrictCode != null) {
      query = query.where('districtCode', isEqualTo: _currentDistrictCode);
    } else if (_currentProvinceCode != null) {
      query = query.where('provinceCode', isEqualTo: _currentProvinceCode);
    }

    // if (_currentPropertyUtilities.isNotEmpty) {
    //   query = query.where('utilities',
    //       isGreaterThanOrEqualTo: _currentPropertyUtilities);
    // }
    final al = AppLocalizations.of(context)!;

    await _propertyService.getPropertiesByQuery(query).then((items) {
      if (items.isEmpty) {
        showErrorDialog(context, title: al.sorry, content: al.dontHaveProperty);
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultView(
            title: al.result,
            items: items,
          ),
        ),
      );
    });
  }
}

class Ward {
  int code;
  int districtCode;
  String name;

  Ward({
    required this.code,
    required this.districtCode,
    required this.name,
  });
}

class District {
  int code;
  int provinceCode;
  String name;
  District({
    required this.code,
    required this.provinceCode,
    required this.name,
  });
}

class Province {
  int code;
  String name;

  Province({
    required this.code,
    required this.name,
  });
}
