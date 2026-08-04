import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:aunjai/services/analysis_service.dart';
import 'package:aunjai/models/analysis_result.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class MessageType {
  final int method;
  final List<String> msglist;

  MessageType(this.method, this.msglist);
}

class _MessageState extends State<Message> {
  final List<TextEditingController> _controllers = [
    TextEditingController(),
  ];
  final AnalysisService _analysisService = AnalysisService();
  bool _isLoading = false;

  @override
  void dispose() {
    // Clean up all dynamically generated controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Tracks which tab is selected: 0 = SMS, 1 = แชท, 2 = Email
  int _selectedTabIndex = 0;

  void analyzeMessage() async {
    final List<String> msgList = _controllers
      .map((controller) => controller.text.trim())
      .where((text) => text.isNotEmpty)
      .toList();

    if (msgList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาพิมพ์ข้อความก่อน')),
      );
      return;
    }

    final platforms = ['sms', 'line', 'email'];
    final platform = platforms[_selectedTabIndex];

    setState(() => _isLoading = true);
    try {
      final result = await _analysisService.analyzeChat(msgList, platform);
      if (mounted) {
        context.go('/result', extra: result);
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_analysisService.getErrorMessage(e)),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .transparent, // Let the main shell's halo background show through
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
                // If using go_router:
                context.go('/home');
                // Otherwise fallback:
                //Navigator.of(context).pop();
              },
            ),
          ),
        ),
        title: const Text(
          "อุ่นใจ Message",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(
          context,
        ).unfocus(), // Dismiss keyboard on background tap
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Heading Icon and Label
              const Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.blueAccent,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "ข้อความมาจากที่ไหน",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Custom Type Selector Tabs (SMS, Chat, Email)
              Row(
                children: [
                  Expanded(child: _buildTypeTab(Icons.message, "SMS", 0)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTypeTab(Icons.phone_android, "แชท", 1)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTypeTab(Icons.email, "Email", 2)),
                ],
              ),
              const SizedBox(height: 24),

              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _controllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildDynamicTextField(
                      index: index,
                    ), // 👈 Calls your new method
                  );
                },
              ),
              //const SizedBox(height: 12),

              // 4. Centered Plus Button to add a new box dynamically
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _controllers.add(
                        TextEditingController(),
                      ); // Adds a new box control record instantly 🎯
                    });
                  },
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xff2563eb),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff2563eb).withValues(alpha: 0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 6. Insight Notice Card Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff111c30).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.smart_toy),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "ไม่ต้องกังวลนะครับ 😊 อุ่นใจจะช่วยวิเคราะห์ข้อความให้ เพื่อความปลอดภัยที่แม่นยำที่สุดของคุณครับ",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 7. Main Action Dynamic Gradient Button
              Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xff2563eb), Color(0xff7c3aed)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff7c3aed).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    analyzeMessage();
                  },
                  child: const Text(
                    "วิเคราะห์ข้อความ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ), // Ensures clearing height above bottom navigations
            ],
          ),
        ),
      ),
    );
  }

  // Helper builder widget to render custom selected pills
  Widget _buildTypeTab(IconData icon, String label, int index) {
    final bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xff1e293b).withValues(alpha: 0.2)
              : const Color(0xff111827).withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xff2563eb)
                : Colors.white.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.4),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper builder widget to render sleek dark input areas
  Widget _buildDynamicTextField({required int index}) {
    // Generate a friendly label based on position
    final String hintText = index == 0
        ? "วางข้อความแรกที่ได้รับ..."
        : "วางข้อความที่ ${index + 1} (ถ้ามี)...";

    return Stack(
      children: [
        // The Main Input Box Container
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff111827).withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 40,
            top: 8,
            bottom: 8,
          ), // Right padding leaves room for 'X'
          child: TextField(
            controller: _controllers[index],
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.2),
                fontSize: 16,
              ),
              border: InputBorder.none,
            ),
          ),
        ),

        // Show the 'X' button on the top-right corner for any box except the very first one
        if (index > 0)
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _controllers[index].dispose(); // Free memory resource
                  _controllers.removeAt(
                    index,
                  ); // Remove the box row from UI layout ❌
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
