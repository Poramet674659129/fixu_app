import 'package:flutter/material.dart';

class NewsItem {
  final String title;
  final String category;
  final String location;
  final String date;
  final String content;
  final IconData icon;
  final Color iconBgColor;

  const NewsItem({
    required this.title,
    required this.category,
    required this.location,
    required this.date,
    required this.content,
    required this.icon,
    required this.iconBgColor,
  });
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['ทั้งหมด', 'ปรับปรุงระบบ', 'ประกาศมหาวิทยาลัย'];

  final List<NewsItem> _newsList = const [
    NewsItem(
      title: 'แจ้งปรับปรุงระบบไฟฟ้า',
      category: 'ปรับปรุงระบบ',
      location: 'อาคารเรียนรวม ชั้น 2',
      date: '1-5 มิ.ย. 2567',
      content: 'ฝ่ายอาคารสถานที่ขอแจ้งปรับปรุงระบบไฟฟ้าทดสอบตู้ควบคุมไฟฟ้าหลัก อาคารเรียนรวม ชั้น 2 เพื่อความปลอดภัยในการใช้งาน โปรดหลีกเลี่ยงการใช้ปลั๊กไฟชั่วคราวในช่วงเวลาดังกล่าว',
      icon: Icons.electric_bolt,
      iconBgColor: Color(0xFFEFF6FF),
    ),
    NewsItem(
      title: 'ปิดปรับปรุงระบบประปาชั่วคราว',
      category: 'ปรับปรุงระบบ',
      location: 'อาคารหอพักนักศึกษา 1-3',
      date: '10 มิ.ย. 2567 (09:00 - 15:00 น.)',
      content: 'ทำการซ่อมบำรุงท่อน้ำประปาหลักที่จ่ายเข้าอาคารหอพักนักศึกษา ส่งผลให้น้ำประปาไหลอ่อนหรือไม่ไหลชั่วคราว กรุณาสำรองน้ำไว้ใช้งานล่วงหน้า',
      icon: Icons.water_drop_outlined,
      iconBgColor: Color(0xFFE0F2FE),
    ),
    NewsItem(
      title: 'ตรวจสอบระบบเครื่องปรับอากาศประจำปี',
      category: 'ปรับปรุงระบบ',
      location: 'อาคารเรียนรวม และ อาคารวิจัย',
      date: '15-20 มิ.ย. 2567',
      content: 'ช่างเทคนิคจะเข้าดำเนินการล้างทำความสะอาดแผ่นกรองอากาศและเช็กระบบทำความเย็นเครื่องปรับอากาศในทุกห้องเรียน',
      icon: Icons.ac_unit_outlined,
      iconBgColor: Color(0xFFF1F5F9),
    ),
    NewsItem(
      title: 'เปิดใช้งานระบบแจ้งซ่อม FixU เวอร์ชันใหม่',
      category: 'ประกาศมหาวิทยาลัย',
      location: 'มหาวิทยาลัย',
      date: '1 มิ.ย. 2567',
      content: 'ยินดีต้อนรับสู่ FixU แอปพลิเคชันแจ้งซ่อมในมหาวิทยาลัยรูปแบบใหม่ นศ. และบุคลากรสามารถแจ้งปัญหา ติดตามสถานะ และแนบรูปภาพได้รวดเร็วยิ่งขึ้น',
      icon: Icons.campaign_outlined,
      iconBgColor: Color(0xFFFEF3C7),
    ),
  ];

  List<NewsItem> get _filteredNews {
    if (_selectedCategoryIndex == 1) {
      return _newsList.where((n) => n.category == 'ปรับปรุงระบบ').toList();
    } else if (_selectedCategoryIndex == 2) {
      return _newsList.where((n) => n.category == 'ประกาศมหาวิทยาลัย').toList();
    }
    return _newsList;
  }

  void _showNewsDetailModal(BuildContext context, NewsItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: item.iconBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: const Color(0xFF0265D8), size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0265D8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Color(0xFFF1F5F9)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF64748B)),
                  const SizedBox(width: 6),
                  Text(
                    item.location,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF0265D8)),
                  const SizedBox(width: 6),
                  Text(
                    item.date,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF0265D8), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                item.content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF334155),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0265D8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('ปิด', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
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
          'ข่าวสารและประกาศ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_categories.length, (index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(_categories[index]),
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
                            _selectedCategoryIndex = index;
                          });
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // News List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: _filteredNews.length,
              itemBuilder: (context, index) {
                final item = _filteredNews[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                  child: InkWell(
                    onTap: () => _showNewsDetailModal(context, item),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: item.iconBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(item.icon, color: const Color(0xFF0265D8), size: 26),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.location,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 14,
                                      color: Color(0xFF0265D8),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.date,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0265D8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
