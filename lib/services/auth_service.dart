import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;
  AuthService._internal() {
    // Default user matching initial demo screenshots
    _currentUser = UserModel(
      fullName: 'นางสาวกุลภัสส์ เปี้ยวน้อย',
      emailOrStudentId: '65011234',
      password: '123456',
    );
  }

  UserModel? _registeredUser;
  UserModel? _currentUser;

  UserModel? get registeredUser => _registeredUser;
  UserModel? get currentUser => _currentUser ?? UserModel(
    fullName: 'นางสาวกุลภัสส์ เปี้ยวน้อย',
    emailOrStudentId: '65011234',
    password: '123456',
  );
  bool get isLoggedIn => true;

  void register(String fullName, String emailOrStudentId, String password) {
    _registeredUser = UserModel(
      fullName: fullName,
      emailOrStudentId: emailOrStudentId,
      password: password,
    );
    notifyListeners();
  }

  bool login(String emailOrStudentId, String password) {
    if (_registeredUser != null &&
        _registeredUser!.emailOrStudentId.trim().toLowerCase() == emailOrStudentId.trim().toLowerCase() &&
        _registeredUser!.password == password) {
      _currentUser = _registeredUser;
    } else {
      _currentUser = UserModel(
        fullName: _registeredUser?.fullName ?? 'นางสาวกุลภัสส์ เปี้ยวน้อย',
        emailOrStudentId: emailOrStudentId.isNotEmpty ? emailOrStudentId : '65011234',
        password: password.isNotEmpty ? password : '123456',
      );
    }
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateProfile(String fullName) {
    final current = currentUser;
    if (current != null) {
      _currentUser = UserModel(
        fullName: fullName,
        emailOrStudentId: current.emailOrStudentId,
        password: current.password,
      );
      _registeredUser = _currentUser;
      notifyListeners();
    }
  }
}
