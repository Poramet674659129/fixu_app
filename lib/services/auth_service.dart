import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;
  AuthService._internal();

  UserModel? _registeredUser;
  UserModel? _currentUser;

  UserModel? get registeredUser => _registeredUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  bool isTechnicianEmail(String email) {
    final lower = email.trim().toLowerCase();
    return lower.contains('.ch');
  }

  Future<bool> register(String fullName, String emailOrStudentId, String password) async {
    final isTech = isTechnicianEmail(emailOrStudentId);
    _registeredUser = UserModel(
      fullName: fullName,
      emailOrStudentId: emailOrStudentId,
      password: password,
      role: isTech ? UserRole.technician : UserRole.student,
    );
    notifyListeners();

    // Sync to MySQL Database via ApiService
    await ApiService.instance.registerUser(fullName, emailOrStudentId, password);
    return true;
  }

  Future<bool> login(String emailOrStudentId, String password, {UserRole role = UserRole.student}) async {
    final inputUsername = emailOrStudentId.trim().toLowerCase();
    final isTechEmail = isTechnicianEmail(inputUsername);

    // 1. Try MySQL API authentication
    final apiUser = await ApiService.instance.loginUser(inputUsername, password);
    if (apiUser != null) {
      if (role == UserRole.technician && !isTechEmail && !apiUser.isTechnician) {
        return false; // Reject non-.ch email on technician login
      }
      _currentUser = apiUser;
      _registeredUser = apiUser;
      notifyListeners();
      return true;
    }

    // 2. Local memory authentication
    if (_registeredUser != null) {
      final registeredUsername = _registeredUser!.emailOrStudentId.trim().toLowerCase();
      if (inputUsername.isNotEmpty &&
          inputUsername == registeredUsername &&
          password == _registeredUser!.password) {
        
        // Strict technician validation (Must contain .ch)
        if (role == UserRole.technician && !isTechEmail && !_registeredUser!.isTechnician) {
          return false;
        }

        _currentUser = _registeredUser;
        notifyListeners();
        return true;
      }
    }

    // 3. Demo fallback login for any technician email containing .ch
    if (role == UserRole.technician && isTechEmail && password == '123456') {
      final techUser = UserModel(
        fullName: 'นายปรเมศวร์ ใจดี (ช่างเทคนิค)',
        emailOrStudentId: emailOrStudentId,
        password: password,
        role: UserRole.technician,
      );
      _currentUser = techUser;
      _registeredUser = techUser;
      notifyListeners();
      return true;
    }

    return false;
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
        role: _currentUser!.role,
      );
      _registeredUser = _currentUser;
      notifyListeners();
    }
  }
}
