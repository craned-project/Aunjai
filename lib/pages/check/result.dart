import 'package:aunjai/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sleek dark theme colors matching your design
    const scaffoldBg = Color(0xff091026);

    // 1. คะแนนจากทั้ง 3 เกณฑ์การประเมิน
    const int actionScore = 75;
    const int identityScore = 35;
    const int contextScore = 90;

    // 2. คำนวณคะแนนเฉลี่ยรวมอัตโนมัติ (คะแนนรวมกัน หารด้วย 3 และทำเป็นเปอร์เซ็นต์ 0.0 - 1.0)
    double dangerPercent = ((actionScore + identityScore + contextScore) / 3) / 100;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        bottom: false, 
        child: Column(
          children: [
            // 1. Custom Top App Bar
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
                          dangerPercent > 0.7
                              ? 'logo/red.png'
                              : (dangerPercent > 0.4
                                  ? 'logo/yellow.png'
                                  : 'logo/blue.png'), 
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

                    // Risk Header Section (อัปเดตคำอธิบายระดับความเสี่ยง)
                    _buildMetricBar(
                      label: "ระดับความเสี่ยง",
                      percentage: dangerPercent,
                    ),

                    const SizedBox(height: 24),

                    // Summary Warnings Box (ใช้ Icon ตามรูป)
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
                            icon: Icons.notifications_active_outlined, // เปลี่ยนกลับมาเป็น Icon
                            iconColor: Color(0xfff87171), // สีแดง
                            text:
                                "อุ่นใจขอเตือนนะครับ จากรูปแบบการสนทนาที่ตรวจพบ มีความเสี่ยงสูงที่จะเป็นการหลอกลวง",
                          ),
                          SizedBox(height: 16),
                          _WarningRow(
                            icon: Icons.chat_bubble_outline,
                            iconColor: Colors.white70, // สีขาวเทา
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

                    // 3. ส่วนการ์ดเกณฑ์การประเมินเรียงแบบแนวตั้ง
                    _InsightCard(
                      title: "Action & Request Risk",
                      weight: 30,
                      score: actionScore,
                      description:
                          "ระบบตรวจพบพฤติกรรมที่พยายามให้ผู้ใช้งานโอนเงิน เปิดเผยรหัส หรือให้ข้อมูลสำคัญ ภายใต้แรงกดดันด้านเวลา ซึ่งเป็นสัญญาณการหลอกลวงที่พบบ่อย",
                    ),
                    const SizedBox(height: 16),
                    
                    _InsightCard(
                      title: "Identity Risk",
                      weight: 35,
                      score: identityScore,
                      description:
                          "ตรวจพบการร้องขอให้ยืนยันตัวตนในรูปแบบที่ผิดปกติจากมาตรฐานบัญชีทั่วไป หรือลักษณะบัญชีผู้ส่งมีความน่าสงสัย",
                    ),
                    const SizedBox(height: 16),

                    _InsightCard(
                      title: "Context Risk",
                      weight: 35,
                      score: contextScore,
                      description:
                          "ตรวจพบการติดต่อที่ไม่มีความเชื่อมโยงกับพฤติกรรมในอดีตของผู้ใช้งาน หรือเป็นการอ้างอิงถึงเหตุการณ์ พัสดุ หรือคดีความที่ไม่มีที่มาที่ไป ซึ่งเป็นรูปแบบการสร้างสถานการณ์จำลองที่มิจฉาชีพมักใช้เพื่อเริ่มบทสนทนา",
                    ),
                    
                    const SizedBox(height: 120), 
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // แถบเปอร์เซ็นต์พร้อมคำอธิบายแบบ Pill
  Widget _buildMetricBar({
    required String label,
    required double percentage,
  }) {
    String riskText = percentage > 0.7 
        ? "เสี่ยงมาก" 
        : (percentage > 0.4 ? "เสี่ยงปานกลาง" : "ปลอดภัย");
    
    Color riskColor = percentage > 0.7 
        ? const Color(0xfff87171) 
        : (percentage > 0.4 ? const Color(0xfffbbf24) : const Color(0xff34d399)); 

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 18, 
                fontWeight: FontWeight.bold
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: riskColor.withValues(alpha: 0.1),
                border: Border.all(color: riskColor.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${(percentage * 100).toInt()}% • $riskText",
                style: TextStyle(
                  color: riskColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xff1e293b).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: constraints.maxWidth * percentage, 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: barColor(percentage, 'ai'), // ฟังก์ชันนี้มาจาก utils.dart
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

// อัปเดต Sub-component กลับมารับพารามิเตอร์ Icon และ IconColor
class _WarningRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  const _WarningRow({
    required this.icon, 
    required this.iconColor, 
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
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

// คอมโพเนนต์การ์ดเกณฑ์การประเมิน (คงเดิม)
class _InsightCard extends StatelessWidget {
  final String title;
  final int weight;
  final int score;
  final String description;

  const _InsightCard({
    required this.title,
    required this.weight,
    required this.score,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title, 
                  style: const TextStyle(
                    color: Color(0xfff87171),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "$weight% | $score / 100",
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
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