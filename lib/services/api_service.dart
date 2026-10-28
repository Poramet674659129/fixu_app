import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/repair_item.dart';

class ApiService {
  static final ApiService instance = ApiService._internal();
  factory ApiService() => instance;
  ApiService._internal();

  // Configurable Base URL for MySQL API
  // Points to http://localhost/fixu_api/api.php (or http://10.0.2.2/fixu_api/api.php on Android Emulator)
  static String baseUrl = kIsWeb
      ? 'http://localhost/fixu_api/api.php'
      : (defaultTargetPlatform == TargetPlatform.android
          ? 'http://10.0.2.2/fixu_api/api.php'
          : 'http://localhost/fixu_api/api.php');

  // 1. Register User in MySQL
  Future<bool> registerUser(String fullName, String emailOrStudentId, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName,
          'email_or_student_id': emailOrStudentId,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
    } catch (e) {
      debugPrint('ApiService registerUser error: $e');
    }
    return false;
  }

  // 2. Login User from MySQL
  Future<UserModel?> loginUser(String emailOrStudentId, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email_or_student_id': emailOrStudentId,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' && data['user'] != null) {
          final u = data['user'];
          final isTech = emailOrStudentId.contains('@');
          return UserModel(
            fullName: u['full_name'],
            emailOrStudentId: u['email_or_student_id'],
            password: password,
            role: isTech ? UserRole.technician : UserRole.student,
          );
        }
      }
    } catch (e) {
      debugPrint('ApiService loginUser error: $e');
    }
    return null;
  }

  // 3. Fetch Repair Requests from MySQL
  Future<List<RepairItem>> fetchRepairs() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?action=get_repairs'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' && data['data'] is List) {
          final List list = data['data'];
          return list.map((item) {
            RepairStatus status = RepairStatus.pending;
            if (item['status'] == 'inProgress') {
              status = RepairStatus.inProgress;
            } else if (item['status'] == 'completed') {
              status = RepairStatus.completed;
            } else if (item['status'] == 'cancelled') {
              status = RepairStatus.cancelled;
            }

            return RepairItem(
              id: item['ticket_id'] ?? '#000',
              title: item['category'] ?? '',
              category: item['category'] ?? '',
              location: item['location'] ?? '',
              details: item['details'] ?? '',
              status: status,
              date: item['date_formatted'] ?? '',
              urgency: item['urgency'] ?? 'ปกติ',
              reporterName: item['reporter_name'],
              technicianName: item['technician_name'],
              technicianRole: 'ช่างเทคนิค',
            );
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('ApiService fetchRepairs error: $e');
    }
    return [];
  }

  // 4. Add Repair Request to MySQL
  Future<bool> addRepair(RepairItem item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=add_repair'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ticket_id': item.id,
          'category': item.category,
          'location': item.location,
          'details': item.details,
          'urgency': item.urgency,
          'reporter_name': item.reporterName ?? '',
          'date_formatted': item.date,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
    } catch (e) {
      debugPrint('ApiService addRepair error: $e');
    }
    return false;
  }

  // 5. Update Repair Status in MySQL
  Future<bool> updateRepairStatus(String ticketId, String status, String techName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=update_repair_status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ticket_id': ticketId,
          'status': status,
          'technician_name': techName,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
    } catch (e) {
      debugPrint('ApiService updateRepairStatus error: $e');
    }
    return false;
  }
}
