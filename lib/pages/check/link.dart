import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:aunjai/services/analysis_service.dart';
import 'package:aunjai/models/analysis_result.dart';

class LinkCheck extends StatefulWidget {
  const LinkCheck({super.key});

  @override
  State<LinkCheck> createState() => _LinkCheckState();
}

class _LinkCheckState extends State<LinkCheck> {
  final TextEditingController _linkController = TextEditingController();
  final AnalysisService _analysisService = AnalysisService();
  bool _isLoading = false;

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Syncs with your outer shell background
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
          "อุ่นใจ Safe Link",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Closes keyboard on background tap
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Center Mascot Image Area
              Center(
                child: SizedBox(
                  height: 180,
                  child: Image.asset(
                    'images/link.png', // 👈 Update to match your local asset path
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if asset isn't added yet
                      return const Center(
                        child: Text("🤖\n[Mascot Image]", 
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white38, fontSize: 16)
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Top Info Sub-Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff111c30).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Text(
                  "ถ้ามีลิงก์ที่ไม่แน่ใจว่าปลอดภัย แปะมาที่นี่ได้เลยครับ\nอุ่นใจจะช่วยตรวจสอบให้ละเอียดที่สุด 🛡️",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 3. Section Heading Label
              const Row(
                children: [
                  Icon(Icons.language, color: Colors.white, size: 28),
                  SizedBox(width: 8),
                  Text(
                    "ข้อความที่มีลิงก์ที่ต้องการตรวจสอบ",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 4. Large Dark URL Input Text Area
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff111827).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  controller: _linkController,
                  maxLines: 5, // Taller display to match your mockup layout
                  style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                  decoration: InputDecoration(
                    hintText: 'เช่น “ได้รับลิงก์นี้จาก LINE อ้างว่าเป็นธนาคาร ให้กดเพื่อยืนยันบัญชีภายใน 30 นาท คลิกที่ https://..”',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.25), 
                      fontSize: 16,
                      height: 1.5,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // 5. Main Action Dynamic Gradient Button
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
                    )
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          final String urlToCheck = _linkController.text.trim();
                          if (urlToCheck.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('กรุณากรอกลิงก์ที่ต้องการตรวจสอบ')),
                            );
                            return;
                          }
                          setState(() => _isLoading = true);
                          try {
                            final result = await _analysisService.analyzeLink(urlToCheck, 'line');
                            if (mounted) context.go('/result', extra: result);
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
                        },
                  child: const Text(
                    "ส่งไปตรวจสอบลิงก์",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 100), // Clears room above your bottom tab system
            ],
          ),
        ),
      ),
    );
  }
}