import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aunjai/utils.dart';

class Status {
  final String status;
  final Color textColor;
  final Color bgColor;

  const Status({
    required this.status,
    required this.textColor,
    required this.bgColor,
  });
}

class HistoryItem {
  final String title;
  final int timestamp;
  final int type;
  final int status;

  const HistoryItem({
    required this.title,
    required this.timestamp,
    required this.type,
    required this.status,
  });
}

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // 0 = ทั้งหมด, 1 = ข้อความ, 2 = เบอร์โทร, 3 = ลิงก์, 4 = ภาพ
  // 0 = safe, 1 = sus, 2 = danger!
  int _activeFilterIndex = 0;
  final List<Status> status = [
    Status(
      status: "ปลอดภัย",
      textColor: Color(0xff22c55e),
      bgColor: Color(0xff22c55e),
    ),
    Status(
      status: "น่าสงสัย",
      textColor: Color(0xffeab308),
      bgColor: Color(0xff713f12),
    ),
    Status(
      status: "อันตราย",
      textColor: Color(0xffef4444),
      bgColor: Color(0xff7f1d1d),
    ),
  ];

  List<({int type, IconData icon, String tag})> typeList = [
    (type: 0, icon: Icons.grid_view, tag: "ทั้งหมด"),
    (type: 1, icon: Icons.chat_bubble, tag: "ข้อความ"),
    (type: 2, icon: Icons.phone, tag: "เบอร์โทร"),
    (type: 3, icon: Icons.link, tag: "ลิงก์"),
    (type: 4, icon: Icons.image, tag: "รูปภาพ"),
  ];

  List<HistoryItem> get _filteredHistoryItems {
    if (_activeFilterIndex == 0) {
      return _allHistoryItems; // "ทั้งหมด" -> Show everything
    }

    return _allHistoryItems.where((item) {
      return item.type == _activeFilterIndex;
    }).toList();
  }

  // Mock data matching your exact layout entries
  final List<HistoryItem> _allHistoryItems = [
    const HistoryItem(
      title: "SMS อ้างชื่อรับสิทธิ์เงินกู้",
      timestamp: 1782624319,
      type: 1,
      status: 2,
    ),
    const HistoryItem(
      title: "shopee-th-gift.com",
      timestamp: 1782424319,
      type: 3,
      status: 1,
    ),
    const HistoryItem(
      title: "สลิปธนาคารกสิกรไทย",
      timestamp: 1782512719,
      type: 4,
      status: 0,
    ),
    const HistoryItem(
      title: "เบอร์แปลก +66 81-XXX-XXXX",
      timestamp: 1782513319,
      type: 2,
      status: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .transparent, // Lets shell layout halo backgrounds shine through
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff111827).withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () {
                // Return to home map path depending on routing choice
                context.go('/home');
              },
            ),
          ),
        ),
        title: const Text(
          "ประวัติการตรวจสอบ",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // 1. Horizontal Filter Pills Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: typeList.map((e) {
                return Row(
                  children: [
                    _buildFilterPill(e.tag, e.icon, e.type),
                    SizedBox(width: e.type == 4 ? 0 : 8),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          // 2. Dynamic List of Checked History Cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: _filteredHistoryItems.length,
              itemBuilder: (context, index) {
                final item = _filteredHistoryItems[index];

                // 🎯 Fix: Return the Padding widget, and set its child property!
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildHistoryCard(
                    item,
                  ), // 👈 Assigned directly as the child
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Filter Tab Component
  Widget _buildFilterPill(String label, IconData icon, int index) {
    final bool isActive = _activeFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _activeFilterIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xff2563eb)
              : const Color(0xff1e293b).withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? const Color(0xff3b82f6)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            if (index != 0) ...[
              Icon(
                icon,
                size: 14,
                color: isActive ? Colors.white : Colors.white54,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white70,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Row Card Layout Builder Component
  Widget _buildHistoryCard(HistoryItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff111827).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          // Left Icon Frame Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xff1e293b).withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              typeList[item.type].icon,
              color: Colors.white60,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          // Core Text Description Block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  formatUnixTimestamp(item.timestamp, false),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Status Badge and Dropdown Arrow Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: status[item.status].bgColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: status[item.status].textColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              status[item.status].status,
              style: TextStyle(
                color: status[item.status].textColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_drop_down,
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
