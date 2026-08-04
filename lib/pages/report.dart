import 'package:aunjai/provincelists.dart';
import 'package:aunjai/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:aunjai/core/api_client.dart';
import 'package:aunjai/config/api_config.dart';

class ReportPage extends StatefulWidget {
  final double? actionRisk;
  final double? identityRisk;

  const ReportPage({super.key, this.actionRisk, this.identityRisk});

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
  String _selectedPlatform = 'phone';
  String? _selectedRegion;

  // Risk scores from API: ActionsAndRequest and IdentityRisk (0.0 - 1.0)
  late final double actionRisk;
  late final double identityRisk;

  @override
  void initState() {
    super.initState();
    actionRisk = widget.actionRisk ?? 0.0;
    identityRisk = widget.identityRisk ?? 0.0;
  }

  /// Total risk score = (ActionsAndRequest + IdentityRisk) / 2
  double get totalRiskScore => (actionRisk + identityRisk) / 2;

  final TextEditingController _additionalDetailsController =
      TextEditingController();

  // Mock Dropdown Lists
  final Map<String, String> platforms = {
      'phone': 'โทรศัพท์',
      'line': 'LINE',
      'facebook': 'Facebook',
      'messenger': 'Messenger',
      'email': 'Email',
      'sms': 'SMS',
      'instagram': 'Instagram',
      'twitter': 'Twitter',
      'tiktok': 'TikTok',
      'telegram': 'Telegram',
      'whatsapp': 'WhatsApp'
  };

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
                              "${dangerStatus(totalRiskScore)} (${(totalRiskScore * 100).toInt()}/100)",
                              style: TextStyle(
                                color: barColor(totalRiskScore, 'ai')[0],
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Risk dimension tiles: ActionsAndRequest + IdentityRisk
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricTile("Action & Request", actionRisk),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricTile("Identity Risk", identityRisk),
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

                // 🔹 SECTION 4: Government Filing Intake Form
                _buildSectionHeader("ข้อมูลและช่องทางการรายงาน"),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: _buildCardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Platform Intake Dropdown
                      _buildFormFieldLabel("ช่องทางที่พบภัยหลอกลวง", true),
                      _buildDropdownField<String>(
                        value: _selectedPlatform,
                        items: platforms,
                        onChanged: (val) =>
                            setState(() => _selectedPlatform = val!),
                      ),
                      const SizedBox(height: 18),

                      // Region Intake Dropdown
                      _buildFormFieldLabel("จังหวัดที่เกิดเหตุ", false),
                      _buildDropdownField<String?>(
                        value: _selectedRegion,
                        hint: "เลือกจังหวัดของคุณ",
                        items: provinces,
                        onChanged: (val) =>
                            setState(() => _selectedRegion = val),
                      ),
                      const SizedBox(height: 18),

                      // Text Field Area Input
                      _buildFormFieldLabel(
                        "รายละเอียดข้อมูลที่อยู่ / ข้อมูลเพิ่มเติม", false
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
                    onPressed: () async {
                      final Map<String, dynamic> reportData = {
                        'platform': _selectedPlatform,
                        'region': _selectedRegion,
                        'notes': _additionalDetailsController.text.trim(),
                      };
                      try {
                        await ApiClient().dio.post(ApiConfig.govSubmit, data: reportData);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ส่งรายงานเรียบร้อยแล้ว'),
                            backgroundColor: Color(0xff22c55e),
                          ),
                        );
                        context.go('/home');
                      } on DioException catch (e) {
                        if (!context.mounted) return;
                        final msg = e.response?.data?['detail'] ?? 'เกิดข้อผิดพลาด กรุณาลองใหม่';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msg.toString()),
                            backgroundColor: const Color(0xffef4444),
                          ),
                        );
                      }
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

  Widget _buildFormFieldLabel(String text, bool req) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
          if (req) ...[
            const SizedBox(width: 4),
            Text(
              "*จำเป็น",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight(600)
              ),
            ),
          ]
        ],
      )
    );
  }

  Widget _buildDropdownField<T>({
    required T? value, // Changed to T? so null can show the hint
    String? hint,
    required Map<T, String> items, // Changed Map key to T
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
          // Fix: Use items.entries.map instead of items.map
          items: items.entries.map((entry) {
            return DropdownMenuItem<T>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
