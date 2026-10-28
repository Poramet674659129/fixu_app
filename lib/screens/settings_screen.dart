import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _enableNotifications = true;
  bool _enableEmailAlerts = false;
  bool _enableDarkMode = false;

  void _showChangePasswordDialog() {
    final oldController = TextEditingController();
    final newController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('เปลี่ยนรหัสผ่าน'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'รหัสผ่านปัจจุบัน',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'รหัสผ่านใหม่',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                if (oldController.text.isNotEmpty && newController.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('เปลี่ยนรหัสผ่านเรียบร้อยแล้ว'),
                      backgroundColor: Color(0xFF16A34A),
                    ),
                  );
                }
              },
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'ตั้งค่า',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Settings Group
            const Text(
              'การตั้งค่าทั่วไป',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeTrackColor: const Color(0xFF0265D8),
                    secondary: const Icon(Icons.notifications_outlined, color: Color(0xFF0265D8)),
                    title: const Text('การแจ้งเตือนในแอป', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    value: _enableNotifications,
                    onChanged: (val) {
                      setState(() {
                        _enableNotifications = val;
                      });
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  SwitchListTile(
                    activeTrackColor: const Color(0xFF0265D8),
                    secondary: const Icon(Icons.mark_email_unread_outlined, color: Color(0xFF0265D8)),
                    title: const Text('การแจ้งเตือนผ่านอีเมล', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    value: _enableEmailAlerts,
                    onChanged: (val) {
                      setState(() {
                        _enableEmailAlerts = val;
                      });
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  SwitchListTile(
                    activeTrackColor: const Color(0xFF0265D8),
                    secondary: const Icon(Icons.dark_mode_outlined, color: Color(0xFF0265D8)),
                    title: const Text('โหมดมืด (Dark Mode)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    value: _enableDarkMode,
                    onChanged: (val) {
                      setState(() {
                        _enableDarkMode = val;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(val ? 'เปิดโหมดมืด' : 'ปิดโหมดมืด')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Security Group
            const Text(
              'ความปลอดภัย',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_outline, color: Color(0xFF0265D8)),
                    title: const Text('เปลี่ยนรหัสผ่าน', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
                    onTap: _showChangePasswordDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // About Group
            const Text(
              'เกี่ยวกับแอปพลิเคชัน',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.info_outline, color: Color(0xFF0265D8)),
                    title: Text('เวอร์ชันแอปพลิเคชัน', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: Text('1.0.0', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xFF0265D8)),
                    title: const Text('นโยบายความเป็นส่วนตัว', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('นโยบายความเป็นส่วนตัวของ FixU')),
                      );
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  ListTile(
                    leading: const Icon(Icons.contact_support_outlined, color: Color(0xFF0265D8)),
                    title: const Text('ติดต่อทีมงานผู้พัฒนา', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('อีเมลทีมงาน: support@fixu.ac.th')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  AuthService.instance.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                icon: const Icon(Icons.logout, size: 20),
                label: const Text(
                  'ออกจากระบบ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEE2E2),
                  foregroundColor: const Color(0xFFDC2626),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
