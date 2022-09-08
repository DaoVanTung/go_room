import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';
import 'collection_path.dart';

class AppUserService {
  AppUserService._internal();

  static final _loginController = AppUserService._internal();
  static AppUserService get instance => _loginController;
  final db = FirebaseFirestore.instance;

  Future<AppUser?> getAppUserById(String uid) async {
    AppUser? item;
    final doc = await db.collection(CollectionPath.appUser).doc(uid).get();

    if (doc.data() != null) {
      item = AppUser.fromMap(doc.data()!);
    }

    return item;
  }

  Future saveAppUser(AppUser appUser) async {
    db
        .collection(CollectionPath.appUser)
        .doc(appUser.uid)
        .set(appUser.toMap(), SetOptions(merge: true));
  }

  Future<List<AppUser>> loadAllAppUser() async {
    List<AppUser> items = [];

    final doc = await db.collection(CollectionPath.appUser).get();

    if (doc.docs.isNotEmpty) {
      for (var element in doc.docs) {
        final item = AppUser.fromMap(element.data());
        items.add(item);
      }
    }

    return items;
  }
}
