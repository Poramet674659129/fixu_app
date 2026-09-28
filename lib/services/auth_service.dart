import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;
  AuthService._internal();

  UserModel? _registeredUser;
  UserModel? _currentUser;

  UserModel? get registeredUser => _registeredUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  void register(String fullName, String emailOrStudentId, String password) {
    _registeredUser = UserModel(
      fullName: fullName,
      emailOrStudentId: emailOrStudentId,
      password: password,
    );
    notifyListeners();
  }

  bool login(String emailOrStudentId, String password) {
    if (_registeredUser == null) {
      return false; // Must register first
    }

    final inputUsername = emailOrStudentId.trim().toLowerCase();
    final registeredUsername = _registeredUser!.emailOrStudentId.trim().toLowerCase();

    if (inputUsername.isNotEmpty &&
        inputUsername == registeredUsername &&
        password == _registeredUser!.password) {
      _currentUser = _registeredUser;
      notifyListeners();
      return true;
    }

    return false; // Credentials mismatch
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateProfile(String fullName) {
    if (_currentUser != null) {
      _currentUser = UserModel(
        fullName: fullName,
        emailOrStudentId: _currentUser!.emailOrStudentId,
        password: _currentUser!.password,
      );
      _registeredUser = _currentUser;
      notifyListeners();
    }
  }
}
