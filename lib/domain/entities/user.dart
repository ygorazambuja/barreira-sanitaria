import 'package:flutter/foundation.dart';

class User {
  String username;
  String password;
  String job;
  String profilePic;

  User(
      {@required this.username,
      @required this.password,
      @required this.job,
      this.profilePic});
}
