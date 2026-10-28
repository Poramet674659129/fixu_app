import 'package:flutter/material.dart';
import '../services/api_service.dart';

enum RepairStatus {
  pending('รอดำเนินการ', Color(0xFFEAB308), Color(0xFFFEF9C3)),
  inProgress('กำลังซ่อม', Color(0xFF0265D8), Color(0xFFE0F2FE)),
  completed('ซ่อมเสร็จ', Color(0xFF16A34A), Color(0xFFDCFCE7)),
  cancelled('ยกเลิก', Color(0xFF64748B), Color(0xFFF1F5F9));

  final String label;
  final Color color;
  final Color backgroundColor;

  const RepairStatus(this.label, this.color, this.backgroundColor);
}

class StatusTimelineStep {
  final String title;
  final String? dateTime;
  final bool isCompleted;
  final bool isCurrent;

  StatusTimelineStep({
    required this.title,
    this.dateTime,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}

class RepairItem {
  final String id;
  final String title;
  final String category;
  final String location;
  final String details;
  final RepairStatus status;
  final String date;
  final String urgency;
  final String? reporterName;
  final String? technicianName;
  final String? technicianRole;
  final List<StatusTimelineStep>? timeline;
  final List<String>? imagePaths;

  RepairItem({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.details,
    required this.status,
    required this.date,
    this.urgency = 'ปกติ',
    this.reporterName,
    this.technicianName,
    this.technicianRole,
    this.timeline,
    this.imagePaths,
  });
}

class RepairRepository extends ChangeNotifier {
  static final RepairRepository instance = RepairRepository._internal();
  factory RepairRepository() => instance;
  RepairRepository._internal() {
    fetchFromDatabase();
  }

  final List<RepairItem> _items = [];

  List<RepairItem> get items => List.unmodifiable(_items);

  Future<void> fetchFromDatabase() async {
    final dbRepairs = await ApiService.instance.fetchRepairs();
    if (dbRepairs.isNotEmpty) {
      _items.clear();
      _items.addAll(dbRepairs);
      notifyListeners();
    }
  }

  void addRepairItem(RepairItem item) {
    _items.insert(0, item);
    notifyListeners();

    // Async sync to MySQL database
    ApiService.instance.addRepair(item);
  }

  void updateRepairStatus(String ticketId, RepairStatus newStatus, {String? technicianName}) {
    final index = _items.indexWhere((item) => item.id == ticketId);
    if (index != -1) {
      final existing = _items[index];
      final updatedTimeline = List<StatusTimelineStep>.from(existing.timeline ?? []);
      final now = DateTime.now();
      final timeStr = formatThaiDateTime(now);

      if (newStatus == RepairStatus.inProgress) {
        updatedTimeline.add(
          StatusTimelineStep(
            title: 'ช่างรับเรื่อง/กำลังซ่อม',
            dateTime: timeStr,
            isCompleted: true,
            isCurrent: true,
          ),
        );
      } else if (newStatus == RepairStatus.completed) {
        updatedTimeline.add(
          StatusTimelineStep(
            title: 'ซ่อมเสร็จเรียบร้อย',
            dateTime: timeStr,
            isCompleted: true,
            isCurrent: true,
          ),
        );
      }

      final techName = technicianName ?? existing.technicianName ?? 'ช่างเทคนิค';

      _items[index] = RepairItem(
        id: existing.id,
        title: existing.title,
        category: existing.category,
        location: existing.location,
        details: existing.details,
        status: newStatus,
        date: existing.date,
        urgency: existing.urgency,
        reporterName: existing.reporterName,
        technicianName: techName,
        technicianRole: existing.technicianRole,
        timeline: updatedTimeline,
        imagePaths: existing.imagePaths,
      );
      notifyListeners();

      // Async sync status update to MySQL database
      String statusStr = 'pending';
      if (newStatus == RepairStatus.inProgress) {
        statusStr = 'inProgress';
      } else if (newStatus == RepairStatus.completed) {
        statusStr = 'completed';
      } else if (newStatus == RepairStatus.cancelled) {
        statusStr = 'cancelled';
      }

      ApiService.instance.updateRepairStatus(ticketId, statusStr, techName);
    }
  }
}

String formatThaiDate(DateTime dt) {
  const months = [
    'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
    'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
  ];
  return '${dt.day} ${months[dt.month - 1]} ${dt.year + 543}';
}

String formatThaiDateTime(DateTime dt) {
  const months = [
    'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
    'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
  ];
  final minuteStr = dt.minute.toString().padLeft(2, '0');
  return '${dt.day} ${months[dt.month - 1]} ${dt.year + 543} ${dt.hour}:$minuteStr น.';
}
