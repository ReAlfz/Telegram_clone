import 'package:flutter/foundation.dart';

@immutable
class User {
  final String icon, username, number, uid;

  const User({
    required this.icon,
    required this.username,
    required this.number,
    required this.uid
  });
}