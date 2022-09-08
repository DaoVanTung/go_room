import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/property.dart';
import 'collection_path.dart';

class PropertyService {
  PropertyService._internal();
  static PropertyService get instance => PropertyService._internal();

  final db = FirebaseFirestore.instance;

  Future<Property?> getPropertyById(String propertyId) async {
    Property? item;
    final doc =
        await db.collection(CollectionPath.property).doc(propertyId).get();

    if (doc.data() != null) {
      item = Property.fromMap(doc.data()!);
    }

    return item;
  }

  Future<List<Property>> getPropertiesByQuery(
    Query<Map<String, dynamic>> query,
  ) async {
    List<Property> items = [];

    final doc = await query.get();

    if (doc.docs.isNotEmpty) {
      for (var element in doc.docs) {
        final item = Property.fromMap(element.data());
        items.add(item);
      }
    }

    return items;
  }

  /// Type of property
  /// 0: Motel
  /// 1: Dorm
  /// 2: Apartment
  /// 3: House
  Future<List<Property>> getNewProperties({
    required int propertyType,
    required int provinceCode,
  }) async {
    List<Property> items = [];
    final doc = await db
        .collection(CollectionPath.property)
        .where('provinceCode', isEqualTo: provinceCode)
        .where('type', isEqualTo: propertyType)
        .where('status', isEqualTo: 1)
        .orderBy('creationTime', descending: true)
        .limit(5)
        .get();

    if (doc.docs.isNotEmpty) {
      for (var element in doc.docs) {
        final item = Property.fromMap(element.data());
        items.add(item);
      }
    }

    return items;
  }

  String createNewId() {
    return db.collection(CollectionPath.property).doc().id;
  }

  Future saveProperty(Property property) async {
    db
        .collection(CollectionPath.property)
        .doc(property.propertyId)
        .set(property.toMap(), SetOptions(merge: true));
  }

  Future deleteProperty(String propertyId) async {
    db.collection(CollectionPath.property).doc(propertyId).delete();
  }

  Future<List<Property>> loadTotalWaitingProperty() async {
    List<Property> items = [];
    final doc = await db
        .collection(CollectionPath.property)
        .where('status', isEqualTo: 0)
        .orderBy('creationTime', descending: true)
        .get();

    if (doc.docs.isNotEmpty) {
      for (var element in doc.docs) {
        final item = Property.fromMap(element.data());
        items.add(item);
      }
    }

    return items;
  }

  /// Type of property
  /// 0: Motel
  /// 1: Dorm
  /// 2: Apartment
  /// 3: House
  Future<List<Property>> getNewPropertiesNoLimit({
    required int propertyType,
    required int provinceCode,
  }) async {
    List<Property> items = [];
    final doc = await db
        .collection(CollectionPath.property)
        .where('provinceCode', isEqualTo: provinceCode)
        .where('type', isEqualTo: propertyType)
        .where('status', isEqualTo: 1)
        .orderBy('creationTime', descending: true)
        .get();

    if (doc.docs.isNotEmpty) {
      for (var element in doc.docs) {
        final item = Property.fromMap(element.data());
        items.add(item);
      }
    }

    return items;
  }
}
