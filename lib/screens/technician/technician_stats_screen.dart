import 'package:flutter/material.dart';
import '../../models/repair_item.dart';

class TechnicianStatsScreen extends StatelessWidget {
  const TechnicianStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'สรุปผลและสถิติงาน',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: ListenableBuilder(
          listenable: RepairRepository.instance,
          builder: (context, child) {
            final items = RepairRepository.instance.items;
            final total = items.length;
            final completed = items.where((i) => i.status == RepairStatus.completed).length;
            final inProgress = items.where((i) => i.status == RepairStatus.inProgress).length;
            final pending = items.where((i) => i.status == RepairStatus.pending).length;

            final completionRate = total > 0 ? ((completed / total) * 100).toStringAsFixed(0) : '100';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Completion Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE0F2FE),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$completionRate%',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0265D8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'อัตราปิดงานสำเร็จ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ปิดงานสำเร็จแล้ว $completed จากทั้งหมด $total รายการ',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'ภาพรวมสถานะงานทั้งหมด',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),

                // Stat Cards Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    _buildStatCard(
                      title: 'งานใหม่รอรับเรื่อง',
                      count: '$pending',
                      icon: Icons.hourglass_top_outlined,
                      color: const Color(0xFFFEF9C3),
                      iconColor: const Color(0xFFCA8A04),
                    ),
                    _buildStatCard(
                      title: 'กำลังดำเนินการซ่อม',
                      count: '$inProgress',
                      icon: Icons.handyman_outlined,
                      color: const Color(0xFFE0F2FE),
                      iconColor: const Color(0xFF0265D8),
                    ),
                    _buildStatCard(
                      title: 'ซ่อมเสร็จสิ้นแล้ว',
                      count: '$completed',
                      icon: Icons.check_circle_outline,
                      color: const Color(0xFFDCFCE7),
                      iconColor: const Color(0xFF16A34A),
                    ),
                    _buildStatCard(
                      title: 'งานทั้งหมด',
                      count: '$total',
                      icon: Icons.assignment_outlined,
                      color: const Color(0xFFF1F5F9),
                      iconColor: const Color(0xFF475569),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Text(
                count,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}
