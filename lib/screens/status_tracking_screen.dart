import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/repair_item.dart';

class StatusTrackingScreen extends StatelessWidget {
  const StatusTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passedItem = ModalRoute.of(context)?.settings.arguments as RepairItem?;
    final item = passedItem ?? (RepairRepository.instance.items.isNotEmpty ? RepairRepository.instance.items.first : null);

    if (item == null) {
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
            'ติดตามสถานะ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.build_outlined,
                    size: 56,
                    color: Color(0xFF0265D8),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'ยังไม่มีรายการแจ้งซ่อม',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'เมื่อคุณส่งข้อมูลแจ้งซ่อมแล้ว สามารถเข้ามาติดตามสถานะของรายการได้ที่นี่',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('ไปที่หน้าแจ้งซ่อม'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0265D8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final techName = item.technicianName ?? 'นายสมชาย ใจดี';
    final techRole = item.technicianRole ?? 'ช่างเทคนิค';

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
          'ติดตามสถานะ',
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
            // Top Ticket Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x05000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'รายการแจ้งซ่อม',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: item.status.backgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.status.label,
                          style: TextStyle(
                            color: item.status.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.id,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFF1F5F9), height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF0265D8)),
                      const SizedBox(width: 8),
                      Text(
                        item.location,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.build_outlined, size: 18, color: Color(0xFF0265D8)),
                      const SizedBox(width: 8),
                      Text(
                        item.category,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'วันที่แจ้ง : ${item.date}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Detailed Repair Problem Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'รายละเอียดการแจ้งซ่อม',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.details.isNotEmpty ? item.details : 'ไม่มีรายละเอียดเพิ่มเติม',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475569),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.urgency == 'ด่วน' ? const Color(0xFFFEE2E2) : const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'ความเร่งด่วน: ${item.urgency}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: item.urgency == 'ด่วน' ? const Color(0xFFDC2626) : const Color(0xFF0265D8),
                          ),
                        ),
                      ),
                      if (item.reporterName != null) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'ผู้แจ้ง: ${item.reporterName}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (item.imagePaths != null && item.imagePaths!.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Text(
                      'รูปภาพประกอบ:',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: item.imagePaths!.length,
                        itemBuilder: (context, index) {
                          final path = item.imagePaths![index];
                          return Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              image: DecorationImage(
                                image: kIsWeb
                                    ? NetworkImage(path) as ImageProvider
                                    : FileImage(File(path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Status Timeline Section
            const Text(
              'สถานะปัจจุบัน',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: item.timeline != null && item.timeline!.isNotEmpty
                    ? List.generate(item.timeline!.length, (index) {
                        final step = item.timeline![index];
                        return _buildTimelineItem(
                          title: step.title,
                          time: step.dateTime ?? '-',
                          isCompleted: step.isCompleted,
                          isCurrent: step.isCurrent,
                          isFirst: index == 0,
                          isLast: index == item.timeline!.length - 1,
                        );
                      })
                    : [
                        _buildTimelineItem(
                          title: 'รอช่างติดต่อกลับ',
                          time: '-',
                          isCompleted: true,
                          isCurrent: true,
                          isFirst: true,
                          isLast: false,
                        ),
                        _buildTimelineItem(
                          title: 'กำลังซ่อม',
                          time: '-',
                          isCompleted: false,
                          isCurrent: false,
                          isFirst: false,
                          isLast: false,
                        ),
                        _buildTimelineItem(
                          title: 'ซ่อมเสร็จ',
                          time: '-',
                          isCompleted: false,
                          isCurrent: false,
                          isFirst: false,
                          isLast: true,
                        ),
                      ],
              ),
            ),

            const SizedBox(height: 24),

            // Technician Info Card
            const Text(
              'ผู้รับผิดชอบ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFEFF6FF),
                    child: Icon(
                      Icons.engineering_outlined,
                      color: Color(0xFF0265D8),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          techName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          techRole,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('กำลังโทรหา $techName...')),
                      );
                    },
                    icon: const Icon(Icons.phone, size: 16),
                    label: const Text('ติดต่อช่าง'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0265D8),
                      side: const BorderSide(color: Color(0xFF0265D8)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Contact Staff Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('กำลังเชื่อมต่อเจ้าหน้าที่แอดมิน...')),
                  );
                },
                icon: const Icon(Icons.support_agent_outlined),
                label: const Text(
                  'ติดต่อเจ้าหน้าที่',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF475569),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
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

  Widget _buildTimelineItem({
    required String title,
    required String time,
    required bool isCompleted,
    required bool isCurrent,
    required bool isFirst,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCurrent
                    ? const Color(0xFF0265D8)
                    : isCompleted
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFE2E8F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.circle,
                size: isCompleted ? 18 : 10,
                color: isCompleted || isCurrent ? Colors.white : const Color(0xFF94A3B8),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 44,
                color: isCompleted ? const Color(0xFF22C55E) : const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isCurrent || isCompleted ? FontWeight.bold : FontWeight.w500,
                    color: isCurrent
                        ? const Color(0xFF0265D8)
                        : isCompleted
                            ? const Color(0xFF1E293B)
                            : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 13,
                    color: isCurrent ? const Color(0xFF0265D8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
