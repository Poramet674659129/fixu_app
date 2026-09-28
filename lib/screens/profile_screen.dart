import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('แก้ไขข้อมูลส่วนตัว'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'ชื่อ-นามสกุล',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  AuthService.instance.updateProfile(newName);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('อัปเดตข้อมูลส่วนตัวเรียบร้อยแล้ว')),
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
        centerTitle: true,
        title: const Text(
          'โปรไฟล์',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ListenableBuilder(
          listenable: AuthService.instance,
          builder: (context, child) {
            final currentUser = AuthService.instance.currentUser;
            final fullName = currentUser?.fullName ?? 'นางสาวกุลภัสส์ เปี้ยวน้อย';
            final emailOrStudentId = currentUser?.emailOrStudentId ?? '65011234';

            return Column(
              children: [
                const SizedBox(height: 10),
                // Profile Card Header
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 46,
                            backgroundColor: Color(0xFF0265D8),
                            child: CircleAvatar(
                              radius: 43,
                              backgroundColor: Color(0xFFEFF6FF),
                              child: Icon(Icons.person, size: 52, color: Color(0xFF0265D8)),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _showEditProfileDialog(context, fullName),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0265D8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
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
                        'รหัส/อีเมล: $emailOrStudentId',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Profile Options Group
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      _buildProfileOption(
                        icon: Icons.person_outline,
                        title: 'แก้ไขข้อมูลส่วนตัว',
                        onTap: () => _showEditProfileDialog(context, fullName),
                      ),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      _buildProfileOption(
                        icon: Icons.lock_outline,
                        title: 'เปลี่ยนรหัสผ่าน',
                        onTap: () {},
                      ),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      _buildProfileOption(
                        icon: Icons.notifications_none,
                        title: 'การแจ้งเตือน',
                        onTap: () {},
                      ),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      _buildProfileOption(
                        icon: Icons.help_outline,
                        title: 'ศูนย์ช่วยเหลือและคำถามที่พบบ่อย',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      AuthService.instance.logout();
                      Navigator.of(context).pushReplacementNamed('/login');
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: const Color(0xFF0265D8)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF334155),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
    );
  }
}
