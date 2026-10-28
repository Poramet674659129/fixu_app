import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onSelectTab;

  const HomeScreen({super.key, this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top User Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: const BoxDecoration(
                  color: Color(0xFF025DD2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListenableBuilder(
                          listenable: AuthService.instance,
                          builder: (context, child) {
                            final currentUser = AuthService.instance.currentUser;
                            final userName = currentUser?.fullName ?? 'นางสาวกุลภัสส์ เปี้ยวน้อย';

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'สวัสดี',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'ยินดีต้อนรับสู่ FixU',
                                  style: TextStyle(
                                    color: Color(0xE6FFFFFF),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        // Profile Avatar
                        GestureDetector(
                          onTap: () {
                            if (onSelectTab != null) {
                              onSelectTab!(3);
                            }
                          },
                          child: const CircleAvatar(
                            radius: 26,
                            backgroundColor: Color(0x33FFFFFF),
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Notification Alert Banner
                    InkWell(
                      onTap: () => Navigator.of(context).pushNamed('/news'),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0x26FFFFFF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0x33FFFFFF),
                          ),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEF4444),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Text(
                                      '2',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'มีเรื่องแจ้งเตือน 2 รายการ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Main Menu Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'เมนูหลัก',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3 x 2 Grid of Menus
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.95,
                      children: [
                        _buildMenuItem(
                          context,
                          icon: Icons.build_outlined,
                          title: 'แจ้งซ่อม',
                          onTap: () {
                            if (onSelectTab != null) {
                              onSelectTab!(1);
                            }
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.manage_search,
                          title: 'ติดตามสถานะ',
                          onTap: () {
                            Navigator.of(context).pushNamed('/status');
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.history,
                          title: 'ประวัติการแจ้ง',
                          onTap: () {
                            if (onSelectTab != null) {
                              onSelectTab!(2);
                            }
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.article_outlined,
                          title: 'ข่าวสาร',
                          onTap: () {
                            Navigator.of(context).pushNamed('/news');
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.person_outline,
                          title: 'ข้อมูลส่วนตัว',
                          onTap: () {
                            if (onSelectTab != null) {
                              onSelectTab!(3);
                            }
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.settings_outlined,
                          title: 'ตั้งค่า',
                          onTap: () {
                            Navigator.of(context).pushNamed('/settings');
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Announcement Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ประกาศล่าสุด',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/news');
                          },
                          child: const Text(
                            'ดูทั้งหมด >',
                            style: TextStyle(
                              color: Color(0xFF025DD2),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Announcement Card
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/news');
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x08000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.electric_bolt,
                                color: Color(0xFF025DD2),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'แจ้งปรับปรุงระบบไฟฟ้า',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'อาคารเรียนรวม ชั้น 2',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: 14,
                                        color: Color(0xFF025DD2),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '1-5 มิ.ย. 2567',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF025DD2),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF025DD2),
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
