import 'package:aunjai/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImageCheckPage extends StatefulWidget {
  const ImageCheckPage({super.key});

  @override
  State<ImageCheckPage> createState() => _ImageCheckPageState();
}

class _ImageCheckPageState extends State<ImageCheckPage> {
  // 🎯 ADJUSTABLE VARIABLES: Tweak these to change your bar values dynamically!
  double aiGeneratedPercentage = 0.70;
  double humanCreatedPercentage = 0.30;
  int currentTabIdx = 0;

  List<String> desc = ["รูปภาพนี้มีแนวโน้มที่จะเป็น scam สูงครับ", "โปรดอย่าหลงเชื่อหรือทำตามรูปภาพดังกล่าวนะครับ"];
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
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.go('/image/upload'),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            "ผลการประเมิน",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => {context.go('/report')},
                        child: const Icon(
                          Icons.report,
                          color: Colors.redAccent,
                          size: 28,
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
                        /*Container(
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
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),*/

                        // Metrics Section Headings Label
                        const Text(
                          "ผลการประเมิน",
                          style: TextStyle(
                            fontSize: 18,
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
                          barGradientColors: barColor(
                            aiGeneratedPercentage,
                            'ai',
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 🎯 ADJUSTABLE BAR 2: Human Created Performance Tracker
                        _buildMetricBar(
                          label: "สร้างโดยมนุษย์",
                          icon: Icons.person,
                          percentage: humanCreatedPercentage,
                          barGradientColors: barColor(
                            humanCreatedPercentage,
                            'human',
                          ),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "คำแนะนำของอุ่นใจนะครับ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.55,
                                ),
                              ),
                              Column(
                                children: desc.map((description) {
                                  return Row(
                                    children: [
                                      Text(
                                        "\u2022 ",
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                          fontSize: 20,
                                          height: 1.55,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          description,
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.7,
                                            ),
                                            fontSize: 16,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
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
