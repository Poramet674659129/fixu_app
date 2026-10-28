import 'package:flutter/material.dart';
import '../../models/repair_item.dart';
import '../../services/auth_service.dart';

class TechnicianDashboardScreen extends StatefulWidget {
  const TechnicianDashboardScreen({super.key});

  @override
  State<TechnicianDashboardScreen> createState() => _TechnicianDashboardScreenState();
}

class _TechnicianDashboardScreenState extends State<TechnicianDashboardScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['งานใหม่', 'กำลังซ่อม', 'เสร็จสิ้น', 'ทั้งหมด'];

  List<RepairItem> _getFilteredItems(List<RepairItem> items) {
    if (_selectedFilterIndex == 0) {
      return items.where((item) => item.status == RepairStatus.pending).toList();
    } else if (_selectedFilterIndex == 1) {
      return items.where((item) => item.status == RepairStatus.inProgress).toList();
    } else if (_selectedFilterIndex == 2) {
      return items.where((item) => item.status == RepairStatus.completed).toList();
    }
    return items;
  }

  void _acceptJob(RepairItem item, String techName) {
    RepairRepository.instance.updateRepairStatus(
      item.id,
      RepairStatus.inProgress,
      technicianName: techName,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('รับเรื่องแจ้งซ่อมรายการ ${item.id} เรียบร้อยแล้ว'),
        backgroundColor: const Color(0xFF0265D8),
      ),
    );
  }

  void _completeJob(RepairItem item) {
    RepairRepository.instance.updateRepairStatus(
      item.id,
      RepairStatus.completed,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ปิดงานซ่อมรายการ ${item.id} เรียบร้อยแล้ว'),
        backgroundColor: const Color(0xFF16A34A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.instance.currentUser;
    final techName = currentUser?.fullName ?? 'ช่างปรเมศวร์';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Technician Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Color(0xFF025DD2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: ListenableBuilder(
                listenable: RepairRepository.instance,
                builder: (context, child) {
                  final allItems = RepairRepository.instance.items;
                  final pendingCount = allItems.where((i) => i.status == RepairStatus.pending).length;
                  final inProgressCount = allItems.where((i) => i.status == RepairStatus.inProgress).length;
                  final completedCount = allItems.where((i) => i.status == RepairStatus.completed).length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0x33FFFFFF),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'แอปสำหรับช่างเทคนิค',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'สวัสดี $techName',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'ระบบจัดการและรับเรื่องแจ้งซ่อม',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const CircleAvatar(
                            radius: 26,
                            backgroundColor: Color(0x33FFFFFF),
                            child: Icon(
                              Icons.engineering,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Stat Counters Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildHeaderCounterCard(
                              title: 'งานใหม่',
                              count: '$pendingCount',
                              color: const Color(0xFFFEF9C3),
                              textColor: const Color(0xFFCA8A04),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildHeaderCounterCard(
                              title: 'กำลังซ่อม',
                              count: '$inProgressCount',
                              color: const Color(0xFFE0F2FE),
                              textColor: const Color(0xFF0265D8),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildHeaderCounterCard(
                              title: 'เสร็จสิ้น',
                              count: '$completedCount',
                              color: const Color(0xFFDCFCE7),
                              textColor: const Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Filter Tabs
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_filters.length, (index) {
                    final isSelected = _selectedFilterIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(_filters[index]),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0265D8),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF64748B),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? const Color(0xFF0265D8) : const Color(0xFFCBD5E1),
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedFilterIndex = index;
                            });
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Work Orders List
            Expanded(
              child: ListenableBuilder(
                listenable: RepairRepository.instance,
                builder: (context, child) {
                  final allItems = RepairRepository.instance.items;
                  final filteredItems = _getFilteredItems(allItems);

                  if (filteredItems.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 56,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'ไม่มีรายการงานในหมวดหมู่นี้',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return _buildTechnicianJobCard(context, item, techName);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCounterCard({
    required String title,
    required String count,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicianJobCard(BuildContext context, RepairItem item, String techName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row ID & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.id,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.status.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
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
            const SizedBox(height: 8),

            // Category & Location
            Row(
              children: [
                const Icon(Icons.build_outlined, size: 16, color: Color(0xFF0265D8)),
                const SizedBox(width: 6),
                Text(
                  item.category,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.location,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
            if (item.details.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Text(
                  'รายละเอียด: ${item.details}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                ),
              ),
            ],

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 12),

            // Bottom Actions & Details button
            Row(
              children: [
                if (item.reporterName != null)
                  Expanded(
                    child: Text(
                      'ผู้แจ้ง: ${item.reporterName}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/status', arguments: item);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('ดูรายละเอียด', style: TextStyle(fontSize: 12, color: Color(0xFF475569))),
                ),
                const SizedBox(width: 8),

                // Technician State Change Buttons
                if (item.status == RepairStatus.pending)
                  ElevatedButton.icon(
                    onPressed: () => _acceptJob(item, techName),
                    icon: const Icon(Icons.handyman_outlined, size: 16),
                    label: const Text('รับเรื่อง'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0265D8),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  )
                else if (item.status == RepairStatus.inProgress)
                  ElevatedButton.icon(
                    onPressed: () => _completeJob(item),
                    icon: const Icon(Icons.check_circle_outline, size: 16),
                    label: const Text('ปิดงาน'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
