import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email = '';
  String name = '';
  String phoneNumber = '';
  bool active = false;
  Timestamp lastOnlineTimestamp = Timestamp.now();
  String userID;
  String profilePictureURL = '';
  bool selected = false;
  String appIdentifier = 'Carpool ${Platform.operatingSystem}';
  List registeredTournaments;

  User(
      {this.email,
        this.name,
        this.phoneNumber,
        this.active,
        this.lastOnlineTimestamp,
        this.userID,
        this.profilePictureURL,
        this.registeredTournaments});

  String fullName() {
    return '$name';
  }

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
      email: parsedJson['email'] ?? "",
      name: parsedJson['name'] ?? '',
      active: parsedJson['active'] ?? false,
      lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
      phoneNumber: parsedJson['phoneNumber'] ?? "",
      userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
      profilePictureURL: parsedJson['profilePictureURL'] ?? "",
      registeredTournaments: parsedJson['registeredTournaments'] ?? [''],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": this.email,
      "name": this.name,
      "phoneNumber": this.phoneNumber,
      "id": this.userID,
      'active': this.active,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      "profilePictureURL": this.profilePictureURL,
      'appIdentifier': this.appIdentifier,
      'registeredTournaments': this.registeredTournaments,
    };
  }
}

class Settings {
  bool allowPushNotifications = true;

  Settings({this.allowPushNotifications});

  factory Settings.fromJson(Map<dynamic, dynamic> parsedJson) {
    return new Settings(
        allowPushNotifications: parsedJson['allowPushNotifications'] ?? true);
  }

  Map<String, dynamic> toJson() {
    return {'allowPushNotifications': this.allowPushNotifications};
  }
}
