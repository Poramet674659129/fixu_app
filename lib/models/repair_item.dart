import 'package:flutter/material.dart';

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
  RepairRepository._internal();

  final List<RepairItem> _items = List.from(sampleRepairItems);

  List<RepairItem> get items => List.unmodifiable(_items);

  void addRepairItem(RepairItem item) {
    _items.insert(0, item);
    notifyListeners();
  }
}

// Initial sample data matching screens
final List<RepairItem> sampleRepairItems = [
  RepairItem(
    id: '#20240806001',
    title: 'เครื่องปรับอากาศ',
    category: 'เครื่องปรับอากาศ',
    location: 'อาคารเรียนรวม ห้อง 305',
    details: 'แอร์ไม่เย็น เปิดแล้วไม่ค่อยมีลม',
    status: RepairStatus.inProgress,
    date: '6 ส.ค. 2567',
    urgency: 'ปกติ',
    reporterName: 'นางสาวกุลภัสส์ เปี้ยวน้อย',
    technicianName: 'นายสมชาย ใจดี',
    technicianRole: 'ช่างเทคนิค',
    timeline: [
      StatusTimelineStep(
        title: 'รอช่างติดต่อกลับ',
        dateTime: '6 ส.ค. 2567 10:35 น.',
        isCompleted: true,
      ),
      StatusTimelineStep(
        title: 'กำลังซ่อม',
        dateTime: '6 ส.ค. 2567 13:20 น.',
        isCompleted: true,
        isCurrent: true,
      ),
      StatusTimelineStep(
        title: 'ซ่อมเสร็จ',
        dateTime: null,
        isCompleted: false,
      ),
    ],
  ),
  RepairItem(
    id: '#20240728003',
    title: 'ไฟฟ้า',
    category: 'ไฟฟ้า',
    location: 'อาคารเรียนรวม ชั้น 2',
    details: 'ปลั๊กไฟชำรุด ใช้งานไม่ได้',
    status: RepairStatus.completed,
    date: '28 ก.ค. 2567',
    urgency: 'ปกติ',
    reporterName: 'นางสาวกุลภัสส์ เปี้ยวน้อย',
  ),
  RepairItem(
    id: '#20240715002',
    title: 'ประปา',
    category: 'ประปา',
    location: 'อาคารเรียนรวม ชั้น 1',
    details: 'ก๊อกน้ำรั่วในห้องน้ำชาย',
    status: RepairStatus.completed,
    date: '15 ก.ค. 2567',
    urgency: 'ด่วน',
    reporterName: 'นางสาวกุลภัสส์ เปี้ยวน้อย',
  ),
  RepairItem(
    id: '#20240701004',
    title: 'โต๊ะ/เก้าอี้',
    category: 'โต๊ะ/เก้าอี้',
    location: 'อาคารเรียนรวม ห้อง 101',
    details: 'เก้าอี้ขาชำรุด 2 ตัว',
    status: RepairStatus.cancelled,
    date: '1 ก.ค. 2567',
    urgency: 'ปกติ',
    reporterName: 'นางสาวกุลภัสส์ เปี้ยวน้อย',
  ),
];

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
