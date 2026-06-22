import 'package:flutter/material.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "ธีระวิทย์";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. This tells Flutter to let the body scroll completely behind the navigation bar
      extendBody: true,

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0f1c3f), Color(0xff080d1a)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          top: false,
          bottom: false, // Let the background bleed fully under the nav bar
          child: CustomScrollView(
            slivers: [
              // Flush Top Header
              SliverToBoxAdapter(child: _buildHeader()),

              // Main Screen Content
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 20.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildAssistantBanner(),
                    const SizedBox(height: 16),
                    _buildInsightBanner(),
                    const SizedBox(height: 20),
                    _buildFeatureGrid(context),

                    // 2. CRITICAL MARGIN: This leaves empty breathing room at the bottom
                    // so the lowest content can be scrolled fully above the floating bar.
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),

      // 3. This forces the nav bar to permanently float on the screen "no matter what"
      bottomNavigationBar: SafeArea(child: _buildBottomNavigationBar()),
    );
  }

  // --- UI Layout Sub-builders ---

  Widget _buildHeader() {
    // Get the height of the device's status bar area dynamically
    final topPadding = MediaQuery.paddingOf(context).top;

    return ClipRRect(
      // Flush look: only apply the curve to the bottom corners
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          // Internal padding shifts text comfortably away from screen edges and the status bar
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: topPadding + 16.0,
            bottom: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/logo/blue.png',
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 12),

                  // Forces this entire block to calculate its width bounded by the screen size
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "AunJai AI",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "อุ่นใจ AI ผู้ช่วยป้องกันภัยหลอกลวงออนไลน์",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "สวัสดี",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "คุณ $username",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "มีสายแปลกโทรมา? เปิด อุ่นใจ Live Guard ให้ AI ช่วยถามแทน",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssistantBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff1d539c), Color(0xff432b7a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_outlined,
            size: 70,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "อุ่นใจ Assistant",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "ให้ อุ่นใจ ถาม-ตอบแทนคุณ\nพร้อมขอคำแนะนำแบบเรียลไทม์",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    "ลองใช้เลย",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xff12213a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.trending_up, color: Colors.cyanAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(fontSize: 14),
                children: [
                  TextSpan(
                    text:
                        "AI Insight: วันนี้พบกลโกง \"พัสดุตกค้าง\" เพิ่มขึ้น ",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: "32%",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final features = [
      _FeatureData(
        Icons.chat_bubble_outline,
        "Message",
        "SMS / แชท / อีเมล",
        "อุ่นใจ Message",
      ),
      _FeatureData(Icons.image_outlined, "Image", "ภาพหลอกลวง", "อุ่นใจ Image"),
      _FeatureData(
        Icons.newspaper,
        "Fake News",
        "วิเคราะห์ข่าว",
        "อุ่นใจ News",
      ),
      _FeatureData(Icons.language, "Link", "ตรวจเว็บอันตราย", "อุ่นใจ Net"),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 32 - 14) / 2;

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: features.map((item) {
        return Container(
          width: itemWidth,
          height: itemWidth * 0.9,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xff111f38),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 32, color: Colors.cyanAccent),
              const SizedBox(height: 8),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.footer,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 75,
      // Add bottom margin so it hovers gracefully above the bezel
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ).copyWith(bottom: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xff18173c).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildNavItem(Icons.home, "หน้าหลัก", isActive: true),
          _buildNavItem(Icons.notifications_none, "แจ้งเตือน"),

          // Center Elevated Shield Button
          Transform.translate(
            offset: const Offset(-2, -5),
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xff4a35a8), Color(0xff1e51a4)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.shield, color: Colors.white, size: 28),
            ),
          ),

          _buildNavItem(Icons.access_time, "ประวัติ"),
          _buildNavItem(Icons.person_outline, "โปรไฟล์"),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.cyanAccent : Colors.white60,
          size: 22,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? Colors.cyanAccent : Colors.white60,
          ),
        ),
      ],
    );
  }
}

class _FeatureData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String footer;

  _FeatureData(this.icon, this.title, this.subtitle, this.footer);
}
