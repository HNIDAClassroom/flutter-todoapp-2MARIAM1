import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_list_app/models/user.dart';

class UserTheme extends ChangeNotifier {
  int count;
  Color backgroundColor;

  UserTheme({this.count = 5, this.backgroundColor = Colors.black});

  void incrementCount() {
    count++;
    notifyListeners();
  }

  void changeBackgroundColor(Color bgColor) {
    backgroundColor = bgColor;
    notifyListeners();
  }
}

class UserProvider with ChangeNotifier {
  User? _loggedInUser;
  User? get loggedInUser => _loggedInUser;

  void setUser(User user) {
    _loggedInUser = user;
    notifyListeners();
  }

  void logout() {
    _loggedInUser = null;
    notifyListeners();
  }
}
