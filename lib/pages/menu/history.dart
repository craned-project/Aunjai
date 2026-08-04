import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aunjai/utils.dart';
import 'package:aunjai/core/api_client.dart';
import 'package:aunjai/config/api_config.dart';

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
  bool _isLoading = true;
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

  List<HistoryItem> _allHistoryItems = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final response = await ApiClient().dio.get(ApiConfig.scamReports);
      final List<dynamic> data = response.data is List ? response.data : [];
      setState(() {
        _allHistoryItems = data.map((item) {
          final scamType = (item['scam_type'] ?? '').toString().toLowerCase();
          int type;
          if (scamType.contains('sms') || scamType.contains('message') || scamType.contains('chat') || scamType.contains('ข้อความ')) {
            type = 1;
          } else if (scamType.contains('phone') || scamType.contains('call') || scamType.contains('เบอร์')) {
            type = 2;
          } else if (scamType.contains('link') || scamType.contains('url') || scamType.contains('web') || scamType.contains('ลิงก์')) {
            type = 3;
          } else if (scamType.contains('image') || scamType.contains('photo') || scamType.contains('ภาพ') || scamType.contains('รูป')) {
            type = 4;
          } else {
            type = 1;
          }

          final riskLevel = (item['risk_level'] ?? '').toString().toLowerCase();
          final totalScore = item['total_risk_score'] ?? 0;
          int statusIndex;
          if (riskLevel.contains('high') || riskLevel.contains('danger') || totalScore >= 70) {
            statusIndex = 2;
          } else if (riskLevel.contains('medium') || riskLevel.contains('suspect') || totalScore >= 40) {
            statusIndex = 1;
          } else {
            statusIndex = 0;
          }

          final createdAt = item['created_at'] ?? '';
          int timestamp;
          try {
            timestamp = DateTime.parse(createdAt).millisecondsSinceEpoch ~/ 1000;
          } catch (_) {
            timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          }

          final title = item['platform'] ?? item['scam_type'] ?? 'ไม่ระบุ';

          return HistoryItem(
            title: title.toString(),
            timestamp: timestamp,
            type: type,
            status: statusIndex,
          );
        }).toList();
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _filteredHistoryItems.isEmpty
                    ? const Center(
                        child: Text(
                          "ไม่มีประวัติการตรวจสอบ",
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                      )
                    : ListView.builder(
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
