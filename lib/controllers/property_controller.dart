import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/property.dart';
import '../services/property_service.dart';
import '../widgets/app_dialog/app_dialog.dart';
import 'app_controller.dart';
import 'app_user_controller.dart';
import 'auth_controller.dart';

class PropertyController extends ChangeNotifier with AppDialogWidget {
  PropertyController._internal();

  static final _propertyController = PropertyController._internal();
  static PropertyController get instance => _propertyController;
  final PropertyService _propertyService = PropertyService.instance;
  final AppUserController _appUserController = AppUserController.instance;
  final AuthController _authController = AuthController.instance;
  final AppController _appController = AppController.instance;

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

  Future saveProperty(Property property) async {
    _propertyService.saveProperty(property);
  }

  Future deleteProperty(String propertyId) async {
    _propertyService.deleteProperty(propertyId);
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

  Future getDistrictOfProvince() async {
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

  Future getWardOfDistrict() async {
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
    'descKey': GlobalKey<FormFieldState>(),
    'priceKey': GlobalKey<FormFieldState>(),
    'areaKey': GlobalKey<FormFieldState>(),
    'addressKey': GlobalKey<FormFieldState>(),
    'numberOfBedKey': GlobalKey<FormFieldState>(),
    'numberOfBathKey': GlobalKey<FormFieldState>(),
    'electricPriceKey': GlobalKey<FormFieldState>(),
    'waterPriceKey': GlobalKey<FormFieldState>(),
    'phoneNumberKey': GlobalKey<FormFieldState>(),
  };

  GlobalKey<FormFieldState> get titleKey => _textKeys['titleKey']!;
  GlobalKey<FormFieldState> get descKey => _textKeys['descKey']!;
  GlobalKey<FormFieldState> get priceKey => _textKeys['priceKey']!;
  GlobalKey<FormFieldState> get areaKey => _textKeys['areaKey']!;
  GlobalKey<FormFieldState> get addressKey => _textKeys['addressKey']!;
  GlobalKey<FormFieldState> get numberOfBedKey => _textKeys['numberOfBedKey']!;
  GlobalKey<FormFieldState> get numberOfBathKey =>
      _textKeys['numberOfBathKey']!;
  GlobalKey<FormFieldState> get electricPriceKey =>
      _textKeys['electricPriceKey']!;
  GlobalKey<FormFieldState> get waterPriceKey => _textKeys['waterPriceKey']!;
  GlobalKey<FormFieldState> get phoneNumberKey => _textKeys['phoneNumberKey']!;

  final List<XFile> _currentImages = [];
  List<XFile> get currentImages => _currentImages;

  List<XFile> _currentVideos = [];
  List<XFile> get currentVideos => _currentVideos;

  void removeItemOfCurrentImages(XFile item) {
    if (_currentImages.contains(item)) {
      _currentImages.remove(item);
      notifyListeners();
    }
  }

  void onChooseImagePressed() async {
    final imagePicker = ImagePicker();

    final List<XFile>? images = await imagePicker.pickMultiImage();

    if (images != null) {
      for (var element in images) {
        if (_currentImages.contains(element) == false) {
          _currentImages.add(element);
          notifyListeners();
        }
      }
    }
  }

  Future<File> genThumbnailFile(String path) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: path,
      imageFormat: ImageFormat.PNG,
    );
    File file = File(fileName!);
    return file;
  }

  File? currentImageOfVideo;

  void onChooseVideoPressed() async {
    final imagePicker = ImagePicker();

    final XFile? video = await imagePicker.pickVideo(
      source: ImageSource.gallery,
    );

    if (video != null) {
      _currentVideos = [video];
      currentImageOfVideo = await genThumbnailFile(video.path);
      notifyListeners();
    }
  }

  void removeItemOfCurrentVideo() {
    _currentVideos = [];
    notifyListeners();
  }

  /// The user selects a file, and the task is added to the list.
  Future<String?> uploadFile(BuildContext context, {XFile? xfile}) async {
    if (xfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );

      return null;
    }

    Reference ref = FirebaseStorage.instance
        .ref()
        .child(_appUserController.currentAppUser!.uid!)
        .child('/${DateTime.now().millisecondsSinceEpoch}_${xfile.name}');

    await ref.putFile(io.File(xfile.path));

    final link = await ref.getDownloadURL();

    return link;
  }

  void onCreatePropertyPressed(BuildContext context) async {
    final al = AppLocalizations.of(context)!;

    if (_appUserController.currentAppUser == null ||
        _authController.isLogin == false) {
      final snackBar = SnackBar(
        content: Text(al.requireLogin),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    bool check = true;

    _textKeys.forEach((key, value) {
      if (value.currentState?.validate() == false) {
        check = false;
      }
    });

    if (check == false) {
      return;
    }

    if (currentImages.isEmpty) {
      final snackBar = SnackBar(
        content: Text(al.pleaseAddImage),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      final List<String> imageUrls = [];
      for (var element in currentImages) {
        final link = await uploadFile(context, xfile: element);
        if (link != null && imageUrls.contains(link) == false) {
          imageUrls.add(link);
        }
      }

      final List<String> videoUrls = [];
      for (var element in currentVideos) {
        // ignore: use_build_context_synchronously
        final link = await uploadFile(context, xfile: element);
        if (link != null && videoUrls.contains(link) == false) {
          videoUrls.add(link);
        }
      }

      final property = Property(
        propertyId: _propertyService.createNewId(),
        title: titleKey.currentState?.value,
        description: descKey.currentState?.value,
        type: _currentPropertyType,
        price: double.parse(priceKey.currentState?.value),
        area: double.parse(areaKey.currentState?.value),
        electricPrice: double.parse(electricPriceKey.currentState?.value),
        waterPrice: double.parse(waterPriceKey.currentState?.value),
        address: addressKey.currentState?.value,
        provinceCode: currentProvinceCode!,
        districtCode: currentDistrictCode!,
        wardCode: currentWardCode!,
        utilities: currentPropertyUtilities,
        numberOfBath: int.parse(numberOfBathKey.currentState?.value),
        numberOfBed: int.parse(numberOfBedKey.currentState?.value),
        phoneNumber: phoneNumberKey.currentState?.value,
        uid: _appUserController.currentAppUser!.uid!,
        creationTime: DateTime.now().toIso8601String(),
        imageUrls: imageUrls,
        videoUrls: videoUrls,
        status: 0,
      );
      if (_appUserController.currentAppUser!.properties == null) {
        _appUserController.currentAppUser!.properties = [property.propertyId];
      } else {
        _appUserController.currentAppUser!.properties!.add(property.propertyId);
      }
      _appUserController.saveAppUser(_appUserController.currentAppUser!);
      _propertyService.saveProperty(property).then((value) {
        showSuccessDialog(
          context,
          title: 'Yay!',
          content: al.createPropertySuccessful,
        );
      });
    } catch (e) {
      showErrorDialog(
        context,
        title: 'Oops!',
        content: al.somethingWentWrong,
      );
    }

    _appController.isAppBusy = false;
  }

  Future<String> getWardNameByCode(int code) async {
    var client = http.Client();
    try {
      final uri = Uri.parse('https://provinces.open-api.vn/api/w/$code');

      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var body = jsonDecode(utf8.decode(response.bodyBytes));

        return body['name'];
      } else {
        // ignore: avoid_print
        print('Request failed with status: ${response.statusCode}.');
      }
    } finally {
      client.close();
    }
    return '';
  }

  Future<String> getDistrictNameByCode(int code) async {
    var client = http.Client();
    try {
      final uri = Uri.parse('https://provinces.open-api.vn/api/d/$code');

      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var body = jsonDecode(utf8.decode(response.bodyBytes));

        return body['name'];
      } else {
        // ignore: avoid_print
        print('Request failed with status: ${response.statusCode}.');
      }
    } finally {
      client.close();
    }
    return '';
  }

  Future<String> getProvinceNameByCode(int code) async {
    var client = http.Client();
    try {
      final uri = Uri.parse('https://provinces.open-api.vn/api/p/$code');

      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var body = jsonDecode(utf8.decode(response.bodyBytes));

        return body['name'];
      } else {
        // ignore: avoid_print
        print('Request failed with status: ${response.statusCode}.');
      }
    } finally {
      client.close();
    }
    return '';
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
