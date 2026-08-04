import 'package:aunjai/utils.dart';
import 'package:aunjai/models/analysis_result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultPage extends StatefulWidget {
  final AnalysisResult? analysisResult;

  const ResultPage({
    super.key,
    this.analysisResult,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    const scaffoldBg = Color(0xff091026);
    final result = widget.analysisResult;

    final double actionRisk = (result?.actionsScore ?? 0) / 100.0;
    final double identityRisk = (result?.identityScore ?? 0) / 100.0;
    final double dangerPercent = (result?.totalRiskScore ?? 0) / 100.0;
    final suggestions = result?.suggestion ?? [];

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
                    onTap: () => {context.go('/report', extra: {'actionRisk': actionRisk, 'identityRisk': identityRisk})},
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
                      child: Column(
                        children: [
                          if (suggestions.isNotEmpty)
                            ...suggestions.map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _WarningRow(
                                icon: Icons.info_outline,
                                iconColor: dangerPercent > 0.7
                                    ? const Color(0xfff87171)
                                    : const Color(0xfffbbf24),
                                text: s,
                              ),
                            ))
                          else
                            const _WarningRow(
                              icon: Icons.check_circle_outline,
                              iconColor: Color(0xff34d399),
                              text: "ไม่พบสัญญาณความเสี่ยงที่ชัดเจน",
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
                      weight: 50,
                      score: (actionRisk * 100).toInt(),
                      description: result?.actionsDescription ?? "ไม่มีข้อมูล",
                    ),
                    const SizedBox(height: 16),

                    _InsightCard(
                      title: "Identity Risk",
                      weight: 50,
                      score: (identityRisk * 100).toInt(),
                      description: result?.identityDescription ?? "ไม่มีข้อมูล",
                    ),
                    const SizedBox(height: 18),

                    buildGradientButton(context, "รายงานผล", "/report", extra: {'actionRisk': actionRisk, 'identityRisk': identityRisk}),
                    const SizedBox(height: 120)
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

Widget buildGradientButton(BuildContext context, String text, String link, {Object? extra}) {
  return Container(
    width: double.infinity, // Takes full width of the parent container
    decoration: BoxDecoration(
      // Red linear gradient matching the blue-to-purple gradient style
      gradient: const LinearGradient(
        colors: [
          Color(0xFFFF3B30), // Bright vibrant red (left)
          Color.fromARGB(255, 165, 0, 0), // Darker red (right)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(18.0), // Rounded pill corners
    ),
    child: Material(
      color: Colors.transparent, // Allows gradient to show through
      child: InkWell(
        borderRadius: BorderRadius.circular(18.0), // Matches container radius
        onTap: () {
          context.go(link, extra: extra);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0), // Vertical thickness
          child: Center(
            child: Text(
              text, // Your button text
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}