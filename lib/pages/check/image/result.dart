import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImageCheckPage extends StatefulWidget {
  const ImageCheckPage({super.key});

  @override
  State<ImageCheckPage> createState() => _ImageCheckPageState();
}

class _ImageCheckPageState extends State<ImageCheckPage> {
  // 🎯 ADJUSTABLE VARIABLES: Tweak these to change your bar values dynamically!
  double aiGeneratedPercentage = 0.78; // 78%
  double humanCreatedPercentage = 0.62; // 62%
  int currentTabIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff091026), // Match app background theme
      body: Stack(
        children: [
          // 🌌 Background Glows
          Positioned(
            top: 200,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff6366f1).withValues(alpha: 0.15),
                    blurRadius: 100,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),

          // Scrollable Page Content Frame Window
          SafeArea(
            child: Column(
              children: [
                // Custom Navigation App Bar Header Row Layout
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff111827).withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            context.go('/image/upload');
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "อุ่นใจ Image",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content View Area
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // File Upload Area Window Outline Dotted Frame Box
                        Container(
                          width: double.infinity,
                          height: 130,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xff111827,
                            ).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                              style: BorderStyle
                                  .solid, // Swap with dotted border packages if preferred
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open_outlined,
                                color: Colors.white.withValues(alpha: 0.6),
                                size: 36,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "อัปโหลดภาพที่คุณสงสัย\n(เช่น สลิป, แชท, โปรฟีล์, เอกสาร)",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Mascot Center Header Frame Graphic
                        Center(
                          child: SizedBox(
                            height: 200,
                            child: Image.asset(
                              'images/image.png', // Fallbacks safely to 🤖 if path structure changes
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Text(
                                      "🤖",
                                      style: TextStyle(fontSize: 80),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Notification Sub-heading Dialog Banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xff111827,
                            ).withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          child: const Text(
                            "อุ่นใจกำลังดูรายละเอียดในภาพนะครับ\nทั้งจากรูปแบบ AI และมุมมองเชิงมนุษย์",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Metrics Section Headings Label
                        const Text(
                          "ผลการประเมิน",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 🎯 ADJUSTABLE BAR 1: AI Generated Calculation Node Tracker
                        _buildMetricBar(
                          label: "สร้างโดย AI",
                          icon: Icons.smart_toy,
                          percentage: aiGeneratedPercentage,
                          barGradientColors: [
                            const Color(0xffef4444),
                            const Color(0xffb91c1c),
                          ], // Red warning tracking
                        ),
                        const SizedBox(height: 24),

                        // 🎯 ADJUSTABLE BAR 2: Human Created Performance Tracker
                        _buildMetricBar(
                          label: "สร้างโดยมนุษย์",
                          icon: Icons.person,
                          percentage: humanCreatedPercentage,
                          barGradientColors: [
                            const Color(0xffa5f3fc),
                            const Color(0xff6366f1),
                          ], // Smooth cyan-purple flow
                        ),
                        const SizedBox(height: 28),

                        // Detailed Assistant Context Footer Warning Box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xff111827,
                            ).withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            "- อุ่นใจไม่ได้มั่นใจ 100% นะครับ แต่จากภาพนี้มีสัญญาณหลายอย่างที่เข้าข่ายหลอกลวง\n- หากเป็นเรื่องเงินหรือข้อมูลส่วนตัว แนะนำให้หยุดและตรวจสอบเพิ่มเติมก่อนครับ",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Linear metric adjustable fill value tracker bar component widget rendering logic
  Widget _buildMetricBar({
    required String label,
    required IconData icon,
    required double percentage,
    required List<Color> barGradientColors,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            Text(
              "${(percentage * 100).toInt()}%",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 14,
          decoration: BoxDecoration(
            color: const Color(0xff1e293b).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width:
                      constraints.maxWidth *
                      percentage, // Dynamic reactive value scaling configuration node
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: barGradientColors,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Custom Clipper path to cleanly cut out a notch for the floating shield action button
class BottomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);

    double middle = size.width / 2;
    path.lineTo(middle - 45, 0);

    // Smooth Bezier down-curves tracking standard floating system action frames layout
    path.cubicTo(middle - 30, 0, middle - 35, 32, middle, 32);
    path.cubicTo(middle + 35, 32, middle + 30, 0, middle + 45, 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
