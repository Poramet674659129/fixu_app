import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class TechnicianProfileScreen extends StatefulWidget {
  const TechnicianProfileScreen({super.key});

  @override
  State<TechnicianProfileScreen> createState() => _TechnicianProfileScreenState();
}

class _TechnicianProfileScreenState extends State<TechnicianProfileScreen> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.instance.currentUser;
    final fullName = currentUser?.fullName ?? 'นายปรเมศวร์ ใจดี';
    final email = currentUser?.emailOrStudentId ?? 'poramet@mail.ch.com';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'โปรไฟล์ช่างเทคนิค',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Profile Card Header
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 46,
                    backgroundColor: Color(0xFF0265D8),
                    child: CircleAvatar(
                      radius: 43,
                      backgroundColor: Color(0xFFEFF6FF),
                      child: Icon(Icons.engineering, size: 52, color: Color(0xFF0265D8)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'อีเมล: $email',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'สิทธิ์: ช่างเทคนิคประจำอาคาร',
                      style: TextStyle(
                        color: Color(0xFF0265D8),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Online Status Switch
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: SwitchListTile(
                activeTrackColor: const Color(0xFF16A34A),
                secondary: Icon(
                  Icons.circle,
                  color: _isOnline ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
                  size: 20,
                ),
                title: Text(
                  _isOnline ? 'สถานะ: พร้อมรับงาน (Online)' : 'สถานะ: พักรับงาน (Offline)',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                value: _isOnline,
                onChanged: (val) {
                  setState(() {
                    _isOnline = val;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(val ? 'เปลี่ยนสถานะเป็น พร้อมรับงาน' : 'เปลี่ยนสถานะเป็น พักรับงาน'),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Options Group
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.article_outlined, color: Color(0xFF0265D8)),
                    title: const Text('ข่าวสารและประกาศ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
                    onTap: () => Navigator.of(context).pushNamed('/news'),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined, color: Color(0xFF0265D8)),
                    title: const Text('ตั้งค่าระบบ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
                    onTap: () => Navigator.of(context).pushNamed('/settings'),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  ListTile(
                    leading: const Icon(Icons.support_agent_outlined, color: Color(0xFF0265D8)),
                    title: const Text('ติดต่อศูนย์ประสานงานอาคารสถานที่', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('เบอร์ภายในศูนย์อาคาร: 1122')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

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
