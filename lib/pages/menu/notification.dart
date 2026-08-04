import 'package:aunjai/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aunjai/core/api_client.dart';
import 'package:aunjai/config/api_config.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final response = await ApiClient().dio.get(ApiConfig.notifications);
      final List<dynamic> data = response.data is List ? response.data : [];
      if (mounted) {
        setState(() {
          _notifications = data.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      }
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
      backgroundColor: Colors.transparent,
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
                context.go('/home');
              },
            ),
          ),
        ),
        title: const Text(
          "แจ้งเตือนจากระบบ",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _notifications.isEmpty
              ? const Center(
                  child: Text(
                    "ไม่มีการแจ้งเตือน",
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notif = _notifications[index];
                    final title = notif['title'] ?? 'การแจ้งเตือน';
                    final message = notif['message'] ?? '';
                    final type = notif['type'] ?? 'broadcast';
                    final createdAt = notif['created_at'] ?? '';
                    int timestamp;
                    try {
                      timestamp = DateTime.parse(createdAt).millisecondsSinceEpoch ~/ 1000;
                    } catch (_) {
                      timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _buildNotificationCard(title, message, type, timestamp),
                    );
                  },
                ),
    );
  }

  Widget _buildNotificationCard(String title, String message, String type, int timestamp) {
    final icon = type == 'personal' ? Icons.person : Icons.campaign;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1e293b).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formatUnixTimestamp(timestamp, true),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
