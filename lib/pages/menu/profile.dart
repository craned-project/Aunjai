import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:aunjai/utils.dart';
import 'package:aunjai/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;

  // 🎯 Database Field Variables
  String _username = "";
  String _email = "";
  String _phoneNumber = "";
  String _userRegion = "";
  bool _isShieldActive = true;


  @override
  void initState() {
    super.initState();
    _fetchUserDataFromDB();
  }

  Future<void> _fetchUserDataFromDB() async {
    setState(() => _isLoading = true);

    try {
      final profile = await UserService().getProfile();

      setState(() {
        _username = profile.username;
        _email = profile.email;
        _phoneNumber = profile.phone ?? "";
        _userRegion = profile.province ?? "";
        _isShieldActive = profile.isVerified;
        _isLoading = false;
      });
    } on DioException catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(UserService().getErrorMessage(e))),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เกิดข้อผิดพลาด กรุณาลองใหม่')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff091026),
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
        child: Stack(
          children: [
            // Ambient Top Blue Glow
            Positioned(
              top: -40,
              left: 0,
              right: 0,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff3b82f6).withValues(alpha: 0.15),
                      blurRadius: 100,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),

            // Main Content Area
            SafeArea(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xff7c3aed),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh:
                          _fetchUserDataFromDB, // Pull to refresh capability
                      backgroundColor: const Color(0xff111827),
                      color: const Color(0xff7c3aed),
                      child: SingleChildScrollView(
                        // 2. 👇 Use this physics to allow scrolling even when content is short
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                          top: 16.0,
                          bottom: 100.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            // Header Avatar
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  context.go('/settings');
                                },
                                child: Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(
                                        0xff3b82f6,
                                      ).withValues(alpha: 0.8),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xff3b82f6,
                                        ).withValues(alpha: 0.3),
                                        blurRadius: 16,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Container(
                                      color: const Color(0xff111827),
                                      child: const Icon(
                                        Icons.person,
                                        size: 55,
                                        color: Colors.white24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Greeting Row dynamically driven by DB state variable
                            Center(
                              child: Text(
                                "ยินดีต้อนรับ, คุณ $_username",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Dynamic Shield State Indicator Badge
                            if (_isShieldActive)
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xff065f46,
                                    ).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(
                                        0xff059669,
                                      ).withValues(alpha: 0.4),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Color(0xff10b981),
                                        size: 16,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "ระบบป้องกันภัยอุ่นใจเปิดใช้งานแล้ว",
                                        style: TextStyle(
                                          color: Color(0xff34d399),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 32),

                            // SECTION 1: Account info
                            _buildSectionHeader("ข้อมูลบัญชีผู้ใช้งาน"),
                            Container(
                              decoration: _buildCardDecoration(),
                              child: Column(
                                children: [
                                  _buildProfileItem(
                                    icon: Icons.person_outline,
                                    label: "ชื่อผู้ใช้ (Username)",
                                    value: "คุณ $_username",
                                  ),
                                  _buildDivider(),
                                  _buildProfileItem(
                                    icon: Icons.mail_outline,
                                    label: "อีเมลที่ผูกไว้ (Email Account)",
                                    value: maskEmail(_email),
                                  ),
                                  _buildDivider(),
                                  _buildProfileItem(
                                    icon: Icons.vpn_key_outlined,
                                    label: "รหัสผ่าน (Password)",
                                    value: "•••••••••••••",
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),

                            // SECTION 2: Personal info reporting layout context
                            _buildSectionHeader(
                              "ข้อมูลส่วนตัวสำหรับการรายงานภัย",
                            ),
                            Container(
                              decoration: _buildCardDecoration(),
                              child: Column(
                                children: [
                                  _buildProfileItem(
                                    icon: Icons.phone_outlined,
                                    label: "เบอร์โทรศัพท์ติดต่อ (Phone Number)",
                                    value:
                                        _phoneNumber.length >= 3
                                            ? "${_phoneNumber.substring(0, 3)}-XXX-XXXX"
                                            : _phoneNumber,
                                  ),
                                  _buildDivider(),
                                  _buildProfileItem(
                                    icon: Icons.location_on_outlined,
                                    label: "พื้นที่จังหวัด (User Region)",
                                    value: _userRegion,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xff0d152d,
                                ).withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(
                                    0xff3b82f6,
                                  ).withValues(alpha: 0.1),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Security user shield hybrid matching asset layout indicator icon
                                  const Icon(
                                    Icons.shield_outlined,
                                    color: Color(0xff6366f1),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      "ข้อมูลส่วนตัวเหล่านี้จะถูกนำไปใช้จัดทำสถิติ และแนบไปกับการส่งรายงานมิจฉาชีพให้แก่หน่วยงานรัฐบาลไทยเฉพาะเมื่อคุณให้คำยินยอมแบบไม่ระบุตัวตนเท่านั้น",
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.4,
                                        ),
                                        fontSize: 13,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xff60a5fa),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: const Color(0xff0d152d).withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white60, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? "ไม่มีข้อมูล" : value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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
