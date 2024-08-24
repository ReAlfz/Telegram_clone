import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String icon, username, uid;

  const UserModel({
    required this.icon,
    required this.username,
    required this.uid
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'icon': icon,
      'username': username
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      icon: map['icon'],
      username: map['username'],
    );
  }
}