import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:aunjai/utils.dart';
import 'package:aunjai/services/user_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Reactive Toggle Switch States
  bool _shareAnonymousData = true;
  bool _notificationsEnabled = true;
  String _username = "";
  String _email = "";
  int lastUpdated = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final profile = await UserService().getProfile();
      setState(() {
        _username = profile.username;
        _email = profile.email;
      });
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(UserService().getErrorMessage(e))),
        );
      }
    } catch (_) {
      // silently fail, fields remain empty
    }
  }

  Future<void> _showEditDialog({
    required String field,
    required String label,
    required String currentValue,
    bool isPassword = false,
  }) async {
    final controller = TextEditingController(
      text: isPassword ? '' : currentValue,
    );

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff111827),
        title: Text(label, style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: isPassword ? 'ใส่รหัสผ่านใหม่' : 'ใส่ค่าใหม่',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff6366f1)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('ยกเลิก', style: TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('บันทึก', style: TextStyle(color: Color(0xff6366f1))),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty) return;

    try {
      final updated = await UserService().updateProfile(
        username: field == 'username' ? result : null,
        email: field == 'email' ? result : null,
        password: field == 'password' ? result : null,
      );

      setState(() {
        _username = updated.username;
        _email = updated.email;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('บันทึกสำเร็จ')),
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(UserService().getErrorMessage(e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff091026), // App deep background
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
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Back Navigation Row
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
                        onPressed: () {
                          context.go('/profile');
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "ตั้งค่า",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 📦 SECTION 1: การจัดการบัญชี
                _buildSectionHeader("การจัดการบัญชี"),
                Container(
                  decoration: _buildCardDecoration(),
                  child: Column(
                    children: [
                      _buildNavigationRow(
                        icon: Icons.person_outline,
                        title: "เปลี่ยนชื่อผู้ใช้",
                        subtitle: "ปัจจุบัน: ${_username}",
                        onTap: () => _showEditDialog(
                          field: 'username',
                          label: 'เปลี่ยนชื่อผู้ใช้',
                          currentValue: _username,
                        ),
                      ),
                      _buildDivider(),
                      _buildNavigationRow(
                        icon: Icons.mail_outline,
                        title: "เปลี่ยนอีเมล",
                        subtitle: maskEmail(_email),
                        onTap: () => _showEditDialog(
                          field: 'email',
                          label: 'เปลี่ยนอีเมล',
                          currentValue: _email,
                        ),
                      ),
                      _buildDivider(),
                      _buildNavigationRow(
                        icon: Icons.lock_outline,
                        title: "เปลี่ยนรหัสผ่าน",
                        subtitle: "อัปเดตล่าสุด${formatRelativeTime(lastUpdated)}",
                        onTap: () => _showEditDialog(
                          field: 'password',
                          label: 'เปลี่ยนรหัสผ่าน',
                          currentValue: '',
                          isPassword: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 📦 SECTION 2: การตั้งค่าความเป็นส่วนตัว
                _buildSectionHeader("การตั้งค่าความเป็นส่วนตัว"),
                Container(
                  decoration: _buildCardDecoration(),
                  child: Column(
                    children: [
                      _buildToggleRow(
                        icon: Icons.visibility_off_outlined,
                        title: "การแชร์ข้อมูลแบบไม่ระบุตัวตน",
                        subtitle:
                            "ช่วยส่งข้อมูลรายงาน Scam เพื่อพัฒนา AI วิจัย",
                        value: _shareAnonymousData,
                        onChanged: (newValue) {
                          setState(() => _shareAnonymousData = newValue);
                          print(
                            "Share Anonymous Data Toggle changed to: $newValue",
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildToggleRow(
                        icon: Icons.notifications_none_outlined,
                        title: "การแจ้งเตือน",
                        subtitle: "แจ้งเตือนสายโทรและข้อความเสี่ยงด่วน",
                        value: _notificationsEnabled,
                        onChanged: (newValue) {
                          setState(() => _notificationsEnabled = newValue);
                          print("Notifications Toggle changed to: $newValue");
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 📦 SECTION 3: ตัวเลือกขั้นสูง
                _buildSectionHeader("ตัวเลือกขั้นสูง"),
                Container(
                  decoration: _buildCardDecoration(),
                  child: Column(
                    children: [
                      _buildNavigationRow(
                        icon: Icons.download_outlined,
                        title: "ดาวน์โหลดข้อมูล",
                        subtitle:
                            "สำรองประวัติการวิเคราะห์ทั้งหมดของคุณ (.json)",
                        onTap: () =>
                            print("Execute: Download User Data Log Package"),
                      ),
                      _buildDivider(),
                      _buildNavigationRow(
                        icon: Icons.delete_outline_rounded,
                        title: "ลบบัญชี",
                        subtitle: "ลบโปรไฟล์และประวัติการตรวจสอบอย่างถาวร",
                        titleColor: const Color(
                          0xffef4444,
                        ), // Red Alert Theme Accent
                        iconColor: const Color(0xffef4444),
                        onTap: () => print(
                          "Danger Action: Prompt Account Deletion Dialog Overlay",
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header Title Style
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xff60a5fa), // Category Blue Tint Tint
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Unified System Card Blueprint Design Box Wrapper
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: const Color(
        0xff0d152d,
      ).withValues(alpha: 0.6), // Translucent Dark Navy Solid Deck
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
    );
  }

  // Row Type 1: Link Arrow Action Navigation Layout
  Widget _buildNavigationRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color titleColor = Colors.white,
    Color iconColor = Colors.white60,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.35),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withValues(alpha: 0.2),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // Row Type 2: Stateful Toggle Switch Option Component
  Widget _buildToggleRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white60, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(
              0xff6366f1,
            ), // Deep neon indigo active pill
            inactiveThumbColor: Colors.white70,
            inactiveTrackColor: const Color(0xff1e293b),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withValues(alpha: 0.05),
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}
