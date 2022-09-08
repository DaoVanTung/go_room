import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Property {
  /// Property Id
  String propertyId;

  /// Title of property
  String title;

  /// Description of property
  String description;

  /// Type of property
  /// 0: Motel
  /// 1: Dorm
  /// 2: Apartment
  /// 3: House
  int type;

  /// Deposit of property
  double price;

  /// Area of property (m²)
  double area;

  /// Electric price of property
  double electricPrice;

  /// Water price of property
  double waterPrice;

  /// Address
  String address;

  /// Province code
  int provinceCode;

  /// District code
  int districtCode;

  /// Ward code
  int wardCode;

  /// Utilities of property (Hard code)
  List<String> utilities;

  int numberOfBath;
  int numberOfBed;

  /// Phone number to contact
  String phoneNumber;

  /// AppUser Id
  String uid;

  /// Creation time of property
  String creationTime;

  /// Image urls of property
  List<String> imageUrls;

  /// Image urls of property
  List<String> videoUrls;

  /// 0: Wait
  /// 1: Show
  /// 2: Hide
  int status;

  Property({
    required this.propertyId,
    required this.title,
    required this.description,
    required this.type,
    required this.price,
    required this.area,
    required this.electricPrice,
    required this.waterPrice,
    required this.address,
    required this.provinceCode,
    required this.districtCode,
    required this.wardCode,
    required this.utilities,
    required this.numberOfBath,
    required this.numberOfBed,
    required this.phoneNumber,
    required this.uid,
    required this.creationTime,
    required this.imageUrls,
    required this.videoUrls,
    required this.status,
  });

  Property copyWith({
    String? propertyId,
    String? title,
    String? description,
    int? type,
    double? price,
    double? area,
    double? electricPrice,
    double? waterPrice,
    String? address,
    int? provinceCode,
    int? districtCode,
    int? wardCode,
    List<String>? utilities,
    int? numberOfBath,
    int? numberOfBed,
    String? phoneNumber,
    String? uid,
    String? creationTime,
    List<String>? imageUrls,
    List<String>? videoUrls,
    int? status,
  }) {
    return Property(
      propertyId: propertyId ?? this.propertyId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      price: price ?? this.price,
      area: area ?? this.area,
      electricPrice: electricPrice ?? this.electricPrice,
      waterPrice: waterPrice ?? this.waterPrice,
      address: address ?? this.address,
      provinceCode: provinceCode ?? this.provinceCode,
      districtCode: districtCode ?? this.districtCode,
      wardCode: wardCode ?? this.wardCode,
      utilities: utilities ?? this.utilities,
      numberOfBath: numberOfBath ?? this.numberOfBath,
      numberOfBed: numberOfBed ?? this.numberOfBed,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      uid: uid ?? this.uid,
      creationTime: creationTime ?? this.creationTime,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrls: videoUrls ?? this.videoUrls,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'propertyId': propertyId,
      'title': title,
      'description': description,
      'type': type,
      'price': price,
      'area': area,
      'electricPrice': electricPrice,
      'waterPrice': waterPrice,
      'address': address,
      'provinceCode': provinceCode,
      'districtCode': districtCode,
      'wardCode': wardCode,
      'utilities': utilities,
      'numberOfBath': numberOfBath,
      'numberOfBed': numberOfBed,
      'phoneNumber': phoneNumber,
      'uid': uid,
      'creationTime': creationTime,
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
      'status': status,
    };
  }

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      propertyId: map['propertyId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      type: map['type'] as int,
      price: map['price'] as double,
      area: map['area'] as double,
      electricPrice: map['electricPrice'] as double,
      waterPrice: map['waterPrice'] as double,
      address: map['address'] as String,
      provinceCode: map['provinceCode'] as int,
      districtCode: map['districtCode'] as int,
      wardCode: map['wardCode'] as int,
      utilities: List<String>.from((map['utilities'])),
      numberOfBath: map['numberOfBath'] as int,
      numberOfBed: map['numberOfBed'] as int,
      phoneNumber: map['phoneNumber'] as String,
      uid: map['uid'] as String,
      creationTime: map['creationTime'] as String,
      imageUrls: List<String>.from((map['imageUrls'])),
      videoUrls: List<String>.from((map['videoUrls']) ?? []),
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Property.fromJson(String source) =>
      Property.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Property(propertyId: $propertyId, title: $title, description: $description, type: $type, price: $price, area: $area, electricPrice: $electricPrice, waterPrice: $waterPrice, address: $address, provinceCode: $provinceCode, districtCode: $districtCode, wardCode: $wardCode, utilities: $utilities, numberOfBath: $numberOfBath, numberOfBed: $numberOfBed, phoneNumber: $phoneNumber, uid: $uid, creationTime: $creationTime, imageUrls: $imageUrls, videoUrls: $videoUrls, status: $status)';
  }

  @override
  bool operator ==(covariant Property other) {
    if (identical(this, other)) return true;

    return other.propertyId == propertyId &&
        other.title == title &&
        other.description == description &&
        other.type == type &&
        other.price == price &&
        other.area == area &&
        other.electricPrice == electricPrice &&
        other.waterPrice == waterPrice &&
        other.address == address &&
        other.provinceCode == provinceCode &&
        other.districtCode == districtCode &&
        other.wardCode == wardCode &&
        listEquals(other.utilities, utilities) &&
        other.numberOfBath == numberOfBath &&
        other.numberOfBed == numberOfBed &&
        other.phoneNumber == phoneNumber &&
        other.uid == uid &&
        other.creationTime == creationTime &&
        listEquals(other.imageUrls, imageUrls) &&
        listEquals(other.videoUrls, videoUrls) &&
        other.status == status;
  }

  @override
  int get hashCode {
    return propertyId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        type.hashCode ^
        price.hashCode ^
        area.hashCode ^
        electricPrice.hashCode ^
        waterPrice.hashCode ^
        address.hashCode ^
        provinceCode.hashCode ^
        districtCode.hashCode ^
        wardCode.hashCode ^
        utilities.hashCode ^
        numberOfBath.hashCode ^
        numberOfBed.hashCode ^
        phoneNumber.hashCode ^
        uid.hashCode ^
        creationTime.hashCode ^
        imageUrls.hashCode ^
        videoUrls.hashCode ^
        status.hashCode;
  }
}
