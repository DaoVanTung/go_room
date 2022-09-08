// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AppUser {
  String? uid;
  String? displayName;
  String? email;
  DateTime? creationTime;
  DateTime? lastSignInTime;
  String? phoneNumber;
  String? photoURL;

  List<String>? savedProperties;
  List<String>? chatRooms;
  List<String>? properties;

  /// 0 or null: Normal
  /// 1: Approval
  /// 2: Admin
  int? role;
  AppUser({
    this.uid,
    this.displayName,
    this.email,
    this.creationTime,
    this.lastSignInTime,
    this.phoneNumber,
    this.photoURL,
    this.savedProperties,
    this.chatRooms,
    this.properties,
    this.role,
  });

  AppUser copyWith({
    String? uid,
    String? displayName,
    String? email,
    DateTime? creationTime,
    DateTime? lastSignInTime,
    String? phoneNumber,
    String? photoURL,
    List<String>? savedProperties,
    List<String>? chatRooms,
    List<String>? properties,
    int? role,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      creationTime: creationTime ?? this.creationTime,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      savedProperties: savedProperties ?? this.savedProperties,
      chatRooms: chatRooms ?? this.chatRooms,
      properties: properties ?? this.properties,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'creationTime': creationTime?.millisecondsSinceEpoch,
      'lastSignInTime': lastSignInTime?.millisecondsSinceEpoch,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'savedProperties': savedProperties,
      'chatRooms': chatRooms,
      'properties': properties,
      'role': role,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] != null ? map['uid'] as String : null,
      displayName:
          map['displayName'] != null ? map['displayName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      creationTime: map['creationTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['creationTime'] as int)
          : null,
      lastSignInTime: map['lastSignInTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastSignInTime'] as int)
          : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      photoURL: map['photoURL'] != null ? map['photoURL'] as String : null,
      savedProperties: map['savedProperties'] != null
          ? List<String>.from((map['savedProperties']))
          : null,
      chatRooms: map['chatRooms'] != null
          ? List<String>.from((map['chatRooms']))
          : null,
      properties: map['properties'] != null
          ? List<String>.from((map['properties']))
          : null,
      role: map['role'] != null ? map['role'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppUser(uid: $uid, displayName: $displayName, email: $email, creationTime: $creationTime, lastSignInTime: $lastSignInTime, phoneNumber: $phoneNumber, photoURL: $photoURL, savedProperties: $savedProperties, chatRooms: $chatRooms, properties: $properties)';
  }

  @override
  bool operator ==(covariant AppUser other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.displayName == displayName &&
        other.email == email &&
        other.creationTime == creationTime &&
        other.lastSignInTime == lastSignInTime &&
        other.phoneNumber == phoneNumber &&
        other.photoURL == photoURL &&
        listEquals(other.savedProperties, savedProperties) &&
        listEquals(other.chatRooms, chatRooms) &&
        listEquals(other.properties, properties);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        displayName.hashCode ^
        email.hashCode ^
        creationTime.hashCode ^
        lastSignInTime.hashCode ^
        phoneNumber.hashCode ^
        photoURL.hashCode ^
        savedProperties.hashCode ^
        chatRooms.hashCode ^
        properties.hashCode;
  }
}
