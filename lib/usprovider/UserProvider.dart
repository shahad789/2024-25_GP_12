import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _userDocId;
  String? _userName;
  String? _email;
  String? _profileImageUrl;

  String? get userDocId => _userDocId;
  String? get userName => _userName;
  String? get email => _email;
  String? get profileImageUrl => _profileImageUrl;

  void setUser(String docId, String name, String email,
      {String? profileImageUrl}) {
    _userDocId = docId;
    _userName = name;
    _email = email;
    _profileImageUrl = profileImageUrl; // Set profile image URL if provided
    notifyListeners();
  }

  void clearUser() {
    _userDocId = null;
    _userName = null;
    _email = null;
    _profileImageUrl = null; // Clear profile image URL
    notifyListeners();
  }
}
