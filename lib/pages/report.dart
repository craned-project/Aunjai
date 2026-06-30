import 'package:aunjai/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class Evidence {
  final String msg;
  final String? alertPrefix;
  final String? clickableSuffix;

  Evidence({required this.msg, this.alertPrefix, this.clickableSuffix});
}

class _ReportPageState extends State<ReportPage> {
  // 🎯 Interactive Form State Elements
  bool _isAnonymousSubmission = true;
  String _selectedPlatform = 'LINE';
  String? _selectedRegion;

  List<double> scores = [0.85, 0.75, 0.20, 0.90];
  double findAverage(List<double> s) {
    double avg = 0;
    for (double d in scores) {
      avg += d;
    }
    return avg / 4;
  }

  final TextEditingController _additionalDetailsController =
      TextEditingController();

  // Accordion Expand/Collapse States
  bool _isTextAnalysisExpanded = false;
  bool _isQuickModeExpanded = false;
  bool _isImageCheckExpanded = false;

  // Mock Dropdown Lists
  final List<String> _platforms = [
    'LINE',
    'Facebook',
    'Messenger',
    'Telegram',
    'SMS / Call',
  ];
  final List<String> _regions = [
    'กรุงเทพมหานคร',
    'นนทบุรี',
    'สมุทรปราการ',
    'เชียงใหม่',
    'ภูเก็ต',
  ];

  List<Evidence> evidences = [
    Evidence(
      msg: "พบภาพนี้ถูกใช้งานในอินเทอร์เน็ตซ้ำซ้อน: ",
      clickableSuffix: "https://aunjai.gov/img-check/scam-f92",
    ),
    Evidence(
      msg:
          "สถานีตำรวจชื่อ \"สน.ท่าช่าง\" อ้างอิงจากฐานข้อมูลรัฐและ Google Maps",
      alertPrefix: "ไม่พบข้อมูล",
    ),
    Evidence(
      msg:
          "พฤติกรรมผู้ต้องสงสัยมีการร้องขอรหัสความปลอดภัย OTP และพูดจาเร่งรัดให้โอนเงินทันที",
    ),
  ];

  @override
  void dispose() {
    _additionalDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xff091026,
      ), // App core deep space color palette
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff091026), Color(0xff050814)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 16.0,
              bottom: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 SECTION 0: Top Custom Navigation Appbar
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff111827).withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () => context.go('/home'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "ส่งรายงานให้หน่วยงานรัฐ",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // 🔹 SECTION 1: AI Analytics Assessment Scorecards
                _buildSectionHeader("ผลการประเมินโดยอุ่นใจ AI"),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _buildCardDecoration(),
                  child: Column(
                    children: [
                      // Top Row Overview Header Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "ความเสี่ยงภาพรวม",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xffef4444,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(
                                  0xffef4444,
                                ).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              "${dangerStatus(findAverage(scores))} (${(findAverage(scores) * 100).toInt()}/100)",
                              style: TextStyle(
                                color: barColor(findAverage(scores), 'ai')[0],
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Metric Metrics 2x2 Grid Layout
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricTile("ด้านข้อความ", scores[0]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricTile("ด้านพฤติกรรม", scores[1]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricTile("ด้านภาพถ่าย", scores[2]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricTile("Quick Mode", scores[3]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 🔹 SECTION 2: Evidence Audit Findings Summary Bullets
                _buildSectionHeader("สรุปหลักฐานที่พบ"),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: _buildCardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...evidences.asMap().entries.map((entry) {
                        int index = entry.key;
                        var e = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildEvidenceRow(
                              e.msg,
                              alertPrefix: e.alertPrefix,
                              clickableSuffix: e.clickableSuffix,
                            ),
                            // Render the spacer ONLY if this isn't the last item in the list
                            if (index < evidences.length - 1)
                              const SizedBox(height: 14),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 🔹 SECTION 3: Deep Dive Investigation Accordions
                _buildSectionHeader("รายละเอียดผลวิเคราะห์เชิงลึก"),
                _buildExpansionTile(
                  title: "การวิเคราะห์ข้อความ (Text Analysis)",
                  isExpanded: _isTextAnalysisExpanded,
                  onToggle: (val) =>
                      setState(() => _isTextAnalysisExpanded = val),
                  childContent:
                      "รายละเอียดข้อมูลเชิงลึกระบุพบบัญชีคำศัพท์เสี่ยงรวมถึงแบล็คลิสต์ทางพาณิชย์...",
                ),
                const SizedBox(height: 12),
                _buildExpansionTile(
                  title: "การวิเคราะห์ Quick Mode",
                  isExpanded: _isQuickModeExpanded,
                  onToggle: (val) => setState(() => _isQuickModeExpanded = val),
                  childContent:
                      "การตรวจสอบด่วนเสร็จสิ้นภายใน 1.2 วินาที พบคอมโพเนนต์ความเสี่ยงภายนอก...",
                ),
                const SizedBox(height: 12),
                _buildExpansionTile(
                  title: "การวิเคราะห์ภาพ (Image Check)",
                  isExpanded: _isImageCheckExpanded,
                  onToggle: (val) =>
                      setState(() => _isImageCheckExpanded = val),
                  childContent:
                      "ข้อมูล Metadata ของรูปภาพถูกแก้ไข และลายน้ำดิจิทัลตรงกับประวัติแคมเปญฟิชชิง...",
                ),
                const SizedBox(height: 28),

                // 🔹 SECTION 4: Government Filing Intake Form
                _buildSectionHeader("ข้อมูลและช่องทางการรายงาน"),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: _buildCardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dual Action Toggle Row Switcher Buttons
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xff090f22),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildToggleSegment(
                                "ส่งแบบไม่ระบุตัวตน",
                                _isAnonymousSubmission,
                                () {
                                  setState(() => _isAnonymousSubmission = true);
                                },
                              ),
                            ),
                            Expanded(
                              child: _buildToggleSegment(
                                "ส่งพร้อมข้อมูลติดต่อ",
                                !_isAnonymousSubmission,
                                () {
                                  setState(
                                    () => _isAnonymousSubmission = false,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Platform Intake Dropdown
                      _buildFormFieldLabel("ช่องทางที่พบภัยหลอกลวง"),
                      _buildDropdownField<String>(
                        value: _selectedPlatform,
                        items: _platforms,
                        onChanged: (val) =>
                            setState(() => _selectedPlatform = val!),
                      ),
                      const SizedBox(height: 18),

                      // Region Intake Dropdown
                      _buildFormFieldLabel("จังหวัดที่เกิดเหตุ"),
                      _buildDropdownField<String?>(
                        value: _selectedRegion,
                        hint: "เลือกจังหวัดของคุณ",
                        items: _regions,
                        onChanged: (val) =>
                            setState(() => _selectedRegion = val),
                      ),
                      const SizedBox(height: 18),

                      // Text Field Area Input
                      _buildFormFieldLabel(
                        "รายละเอียดข้อมูลที่อยู่ / ข้อมูลเพิ่มเติม",
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff111827).withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: TextField(
                          controller: _additionalDetailsController,
                          maxLines: 3,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                "ระบุอำเภอ ตำบล หรือข้อมูลติดต่อ (ถ้าเลือกเปิดเผย)",
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.2),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Secure Footer Safety Notice Card
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xff1e1b4b).withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xff4338ca,
                            ).withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Icon(
                                Icons.lock_outline,
                                size: 14,
                                color: Color(0xff818cf8),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "ข้อมูลหลักฐานทั้งหมดจะถูกเข้ารหัสความปลอดภัยก่อนส่ง คุณสามารถกดยกเลิกหรือแก้ไขข้อมูลบางส่วนได้ตลอดเวลาก่อนยืนยันเข้าระบบรัฐบาล",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 🔹 SECTION 5: Form Final Action Dispatch Button
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [Color(0xff2563eb), Color(0xff3b82f6)],
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      final Map<String, dynamic> reportData = {
                        'is_anonymous': _isAnonymousSubmission,
                        'platform': _selectedPlatform,
                        'region': _selectedRegion,
                        'notes': _additionalDetailsController.text.trim(),
                      };
                      print(
                        "Packaging security log report payload context context: $reportData",
                      );
                    },
                    child: const Text(
                      "ส่งไปยังฐานข้อมูลของเรา",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Elements & Custom Painters
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xff60a5fa),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: const Color(0xff0d152d).withValues(alpha: 0.6), // Deck
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
    );
  }

  Widget _buildMetricTile(String label, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xff111c3a).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            "${(value * 100).toInt()}/100",
            style: TextStyle(
              color: barColor(value, 'ai')[0],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceRow(
    String text, {
    String? clickableSuffix,
    String? alertPrefix,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6.0, right: 10),
          child: Icon(Icons.circle, size: 5, color: Colors.redAccent),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
                fontFamily: 'Kanit',
              ),
              children: [
                if (alertPrefix != null) ...[
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        alertPrefix,
                        style: const TextStyle(
                          color: Color(0xfff87171),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
                TextSpan(text: text),
                if (clickableSuffix != null)
                  TextSpan(
                    text: clickableSuffix,
                    style: const TextStyle(
                      color: Color(0xff60a5fa),
                      decoration: TextDecoration.underline,
                    ),
                    // 🎯 Attach the tap recognizer directly onto the target text chunk
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print("Navigating to URL: $clickableSuffix");
                        // Optional: Use url_launcher package to open natively in system browser
                        // launchUrl(Uri.parse(clickableSuffix));
                      },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required bool isExpanded,
    required ValueChanged<bool> onToggle,
    required String childContent,
  }) {
    return Container(
      decoration: _buildCardDecoration(),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.remove : Icons.add,
              color: Colors.white38,
              size: 18,
            ),
            onTap: () => onToggle(!isExpanded),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                childContent,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildToggleSegment(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xff1d2c52) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white38,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 2),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required T value,
    String? hint,
    required List<String> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xff111827).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: hint != null
              ? Text(
                  hint,
                  style: const TextStyle(color: Colors.white24, fontSize: 14),
                )
              : null,
          dropdownColor: const Color(0xff0d152d),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white38,
          ),
          isExpanded: true,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          items: items.map((String item) {
            return DropdownMenuItem<T>(value: item as T, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
