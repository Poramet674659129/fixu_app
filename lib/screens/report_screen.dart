import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/repair_item.dart';
import '../services/auth_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _locationController = TextEditingController(text: 'อาคารเรียนรวม ห้อง 305');
  final _detailsController = TextEditingController(text: 'แอร์ไม่เย็น เปิดแล้วไม่ค่อยมีลม');
  
  String _selectedCategory = 'เครื่องปรับอากาศ';
  String _urgencyLevel = 'ปกติ';

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];

  final List<String> _categories = [
    'เครื่องปรับอากาศ',
    'ไฟฟ้า',
    'ประปา',
    'โต๊ะ/เก้าอี้',
    'อินเทอร์เน็ต/เครือข่าย',
    'อื่นๆ',
  ];

  @override
  void dispose() {
    _locationController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (image != null && mounted) {
        setState(() {
          _selectedImages.add(image);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถเลือกรูปภาพได้: $e')),
      );
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'เลือกรูปภาพประกอบ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF0265D8)),
                  title: const Text('เลือกจากคลังรูปภาพ (Gallery)'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: Color(0xFF0265D8)),
                  title: const Text('ถ่ายภาพด้วยกล้อง (Camera)'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submitReport() {
    final location = _locationController.text.trim();
    final details = _detailsController.text.trim();

    if (location.isEmpty || details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกสถานที่และรายละเอียดปัญหา'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final currentUser = AuthService.instance.currentUser;
    final reporterName = currentUser?.fullName ?? 'นางสาวกุลภัสส์ เปี้ยวน้อย';
    final now = DateTime.now();
    final ticketId = '#${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecond.toString().padLeft(3, '0')}';
    final imagePaths = _selectedImages.map((f) => f.path).toList();

    final newItem = RepairItem(
      id: ticketId,
      title: _selectedCategory,
      category: _selectedCategory,
      location: location,
      details: details,
      status: RepairStatus.pending,
      date: formatThaiDate(now),
      urgency: _urgencyLevel,
      reporterName: reporterName,
      technicianName: 'รอจัดสรรช่าง',
      technicianRole: 'ช่างเทคนิค',
      imagePaths: imagePaths,
      timeline: [
        StatusTimelineStep(
          title: 'แจ้งซ่อมสำเร็จ',
          dateTime: formatThaiDateTime(now),
          isCompleted: true,
          isCurrent: true,
        ),
        StatusTimelineStep(
          title: 'รอช่างติดต่อกลับ',
          dateTime: null,
          isCompleted: false,
        ),
        StatusTimelineStep(
          title: 'กำลังซ่อม',
          dateTime: null,
          isCompleted: false,
        ),
        StatusTimelineStep(
          title: 'ซ่อมเสร็จ',
          dateTime: null,
          isCompleted: false,
        ),
      ],
    );

    RepairRepository.instance.addRepairItem(newItem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ส่งข้อมูลแจ้งซ่อมเรียบร้อยแล้ว รายการถูกบันทึกลงในประวัติ'),
        backgroundColor: Color(0xFF0265D8),
      ),
    );

    // Clear form for next time
    setState(() {
      _detailsController.clear();
      _selectedImages.clear();
    });

    Navigator.of(context).pushNamed('/status', arguments: newItem);
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
          'แจ้งซ่อม',
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
            // Photo Attachment Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'รูปภาพประกอบ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                if (_selectedImages.isNotEmpty)
                  Text(
                    'แนบแล้ว ${_selectedImages.length} รูป',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF0265D8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            _selectedImages.isEmpty
                ? InkWell(
                    onTap: _showImagePickerModal,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFCBD5E1),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEFF6FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_a_photo_outlined,
                              color: Color(0xFF0265D8),
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'เพิ่มรูป',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0265D8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _selectedImages.length) {
                          // Add more photo button
                          return InkWell(
                            onTap: _showImagePickerModal,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 110,
                              height: 110,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFCBD5E1),
                                  width: 1.5,
                                ),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: Color(0xFF0265D8),
                                    size: 28,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'เพิ่มอีก',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0265D8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final image = _selectedImages[index];
                        return Stack(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFCBD5E1)),
                                image: DecorationImage(
                                  image: kIsWeb
                                      ? NetworkImage(image.path) as ImageProvider
                                      : FileImage(File(image.path)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 18,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 24),

            // Location Field
            const Text(
              'สถานที่',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF0265D8)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0265D8), width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Problem Category Field
            const Text(
              'ประเภทปัญหา',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.build_outlined, color: Color(0xFF0265D8)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0265D8), width: 1.5),
                ),
              ),
              items: _categories.map((String cat) {
                return DropdownMenuItem<String>(
                  value: cat,
                  child: Text(cat, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B))),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedCategory = val;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            // Problem Details Field
            const Text(
              'รายละเอียดปัญหา',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _detailsController,
              maxLines: 4,
              maxLength: 300,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'อธิบายรายละเอียดปัญหาเพิ่มเติม...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0265D8), width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Urgency Field
            const Text(
              'ความเร่งด่วน',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(
                      child: Text('ปกติ', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    selected: _urgencyLevel == 'ปกติ',
                    selectedColor: const Color(0xFFE0F2FE),
                    labelStyle: TextStyle(
                      color: _urgencyLevel == 'ปกติ' ? const Color(0xFF0265D8) : const Color(0xFF64748B),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _urgencyLevel == 'ปกติ' ? const Color(0xFF0265D8) : const Color(0xFFCBD5E1),
                      ),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _urgencyLevel = 'ปกติ';
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(
                      child: Text('ด่วน', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    selected: _urgencyLevel == 'ด่วน',
                    selectedColor: const Color(0xFFFEE2E2),
                    labelStyle: TextStyle(
                      color: _urgencyLevel == 'ด่วน' ? const Color(0xFFDC2626) : const Color(0xFF64748B),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _urgencyLevel == 'ด่วน' ? const Color(0xFFDC2626) : const Color(0xFFCBD5E1),
                      ),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _urgencyLevel = 'ด่วน';
                        });
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _submitReport,
                icon: const Icon(Icons.send_rounded, size: 20),
                label: const Text(
                  'ส่งแจ้งซ่อม',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0866DA),
                  foregroundColor: Colors.white,
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
