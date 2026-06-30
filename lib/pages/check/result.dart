import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sleek dark theme colors matching your design
    const scaffoldBg = Color(0xff091026);

    double dangerPercent = 0.45;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Custom Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/home'),
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
            ),

            // 2. Main Scrollable Content Layout
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mascot Centerpiece Placeholder
                    Center(
                      child: SizedBox(
                        height: 150,
                        child: Image.asset(
                          dangerPercent > 0.7 ? 'logo/red.png' : (dangerPercent > 0.4 ? 'logo/yellow.png' : 'logo/blue.png'), // Fallbacks safely to 🤖 if path structure changes
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

                    // Risk Header Section
                    _buildMetricBar(
                      label: "ระดับความเสี่ยง",
                      icon: Icons.warning_rounded,
                      percentage: dangerPercent,
                    ),

                    const SizedBox(height: 24),

                    // Summary Warnings Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xff1e293b).withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: const Column(
                        children: [
                          _WarningRow(
                            icon: Icons.shield_outlined,
                            text:
                                "อุ่นใจขอเตือนนะครับ จากรูปแบบการสนทนาที่ตรวจพบ มีความเสี่ยงสูงที่จะเป็นการหลอกลวง",
                          ),
                          SizedBox(height: 16),
                          _WarningRow(
                            icon: Icons.chat_bubble_outline,
                            text:
                                "หน่วยงานจริงจะไม่เร่งให้โอนเงิน และไม่ขอข้อมูลสำคัญผ่านแชทหรือโทรศัพท์",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section Divider Label
                    const Row(
                      children: [
                        Icon(Icons.search, color: Color(0xff38bdf8), size: 20),
                        SizedBox(width: 8),
                        Text(
                          "เกณฑ์การประเมินของระบบ AunJai",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Insight Card 1: Action Risk
                    const _InsightCard(
                      title: "AunJai AI Insight",
                      weight: 30,
                      score: 75,
                      subtitle: "Action & Request Risk",
                      description:
                          "ระบบตรวจพบพฤติกรรมที่พยายามให้ผู้ใช้งานโอนเงิน เปิดเผยรหัส หรือให้ข้อมูลสำคัญ ภายใต้แรงกดดันด้านเวลา ซึ่งเป็นสัญญาณการหลอกลวงที่พบบ่อย",
                    ),
                    const SizedBox(height: 16),

                    // Insight Card 2: Identity Risk
                    const _InsightCard(
                      title: "AunJai AI Insight",
                      weight: 35,
                      score: 35,
                      subtitle: "Identity Risk",
                      description:
                          "ตรวจพบการร้องขอให้ยืนยันตัวตนในรูปแบบที่ผิดปกติจากมาตรฐานบัญชีทั่วไป หรือลักษณะบัญชีผู้ส่งมีความน่าสงสัย",
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBar({
    required String label,
    required IconData icon,
    required double percentage,
  }) {
    List<Color> barColor(double percentage, String mode) {
      List<List<Color>> colorList = [
        [Color(0xff22c55e), Color(0xff22c55e)],
        [Color(0xffeab308), Color(0xff713f12)],
        [const Color(0xffef4444), const Color(0xffb91c1c)],
      ];

      if (percentage > 0.7) {
        return mode == 'ai' ? colorList[2] : colorList[0];
      } else if (percentage > 0.4) {
        return colorList[1];
      }

      return mode == 'ai' ? colorList[0] : colorList[2];
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 24),
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
                      colors: barColor(percentage, 'ai'),
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

// Sub-component: Warning Bullet Rows
class _WarningRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _WarningRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xfff87171), size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// Sub-component: Assessment Metric Cards
class _InsightCard extends StatelessWidget {
  final String title;
  final int weight;
  final int score;
  final String subtitle;
  final String description;

  const _InsightCard({
    required this.title,
    required this.weight,
    required this.score,
    required this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$weight% | $score / 100",
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xfff87171),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
