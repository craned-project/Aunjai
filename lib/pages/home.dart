import 'package:flutter/material.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff0f1c3f), // Soft translucent dark blue on top
            Colors
                .transparent, // Let the holder's background/halo show through at the bottom!
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(), // Your custom flush header widget
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildAssistantBanner(),
                const SizedBox(height: 16),
                _buildInsightBanner(),
                const SizedBox(height: 20),
                _buildFeatureGrid(
                  context,
                ), // Your updated 2x2 grid view layout // Padding room so elements scroll clear of the navbar
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// --- UI Layout Sub-builders ---

Widget _buildHeader() {
  // Get the height of the device's status bar area dynamically
  String username = "ธีระวิทย์";
  return Container(
    // Internal padding shifts text comfortably away from screen edges and the status bar
    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0, bottom: 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/logo/blue.png',
              width: 56,
              height: 56,
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "อุ่นใจ AI ผู้ช่วยป้องกันภัยหลอกลวงออนไลน์",
                    style: TextStyle(
                      fontSize: 12,
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
  );
}

Widget _buildAssistantBanner() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color.fromARGB(146, 29, 84, 156),
          Color.fromARGB(146, 67, 43, 122),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                Icons.shield_outlined,
                size: 32,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),

            const SizedBox(width: 10),
            const Text(
              "อุ่นใจ Assistant",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "ให้ อุ่นใจ ถาม-ตอบแทนคุณพร้อมขอคำแนะนำแบบเรียลไทม์",
          style: TextStyle(
            fontSize: 14,
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          ),
          child: const Text(
            "ลองใช้เลย",
            style: TextStyle(fontWeight: FontWeight.bold),
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
                  text: "AI Insight: วันนี้พบกลโกง \"พัสดุตกค้าง\" เพิ่มขึ้น ",
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
  // Define the list of 4 feature card items from your mockup
  final List<FeatureItem> items = [
    FeatureItem(
      icon: Icons.chat_bubble_outline,
      iconColor: Colors.blueAccent,
      iconBgColor: Colors.blue.withValues(alpha: 0.1),
      title: "Message",
      subtitle: "SMS / แชท / อีเมล",
      actionText: "อุ่นใจ Message",
      onTap: () {},
    ),
    FeatureItem(
      icon: Icons.image_outlined,
      iconColor: Colors.purpleAccent,
      iconBgColor: Colors.purple.withValues(alpha: 0.1),
      title: "Image",
      subtitle: "ภาพหลอกลวง",
      actionText: "อุ่นใจ Image",
      onTap: () {},
    ),
    FeatureItem(
      icon: Icons.assignment_outlined,
      iconColor: Colors.redAccent,
      iconBgColor: Colors.red.withValues(alpha: 0.1),
      title: "Fake News",
      subtitle: "วิเคราะห์ข่าว",
      actionText: "อุ่นใจ News",
      onTap: () {},
    ),
    FeatureItem(
      icon: Icons.language,
      iconColor: Colors.greenAccent,
      iconBgColor: Colors.green.withValues(alpha: 0.1),
      title: "Link",
      subtitle: "ตรวจเว็บอันตราย",
      actionText: "อุ่นใจ Net",
      onTap: () {},
    ),
  ];

  return GridView.count(
    crossAxisCount: 2, // Forces exactly two columns side-by-side
    crossAxisSpacing: 16, // Horizontal spacing between cards
    mainAxisSpacing: 16, // Vertical spacing between cards
    shrinkWrap: true, // Essential inside a CustomScrollView
    physics:
        const NeverScrollableScrollPhysics(), // Allows CustomScrollView to handle the scrolling
    childAspectRatio:
        0.95, // Adjust ratio to make it a perfectly balanced box layout
    children: items.map((item) => _buildCard(item)).toList(),
  );
}

Widget _buildCard(FeatureItem item) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: const Color(0xff111827).withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // 1. Change this to mainAxisSize.min or start so things don't force stretch apart
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Wrap EVERYTHING in a single top Column so they stay grouped together tightly
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: item.iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),

            // 2. Control the exact spacing before the line manually right here!
            const SizedBox(height: 16),
            Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
          ],
        ),

        // This stays locked to the very bottom area of your card bounds
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.actionText,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xff2563eb),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(Icons.arrow_forward, size: 14, color: Color(0xff2563eb)),
          ],
        ),
      ],
    ),
  );
}

class FeatureItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onTap;

  FeatureItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onTap,
  });
}

class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    double cutoutRadius = 42.0; // Size of the circular dip
    double center = size.width / 2;

    path.lineTo(center - cutoutRadius - 10, 0);

    // Smoothly curve down into the circular cutout region
    path.quadraticBezierTo(
      center - cutoutRadius,
      0,
      center - cutoutRadius + 5,
      12,
    );

    // Create the inner crescent arc for the shield button base
    path.arcToPoint(
      Offset(center + cutoutRadius - 5, 12),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );

    // Smoothly curve back out to the top flat bar line
    path.quadraticBezierTo(
      center + cutoutRadius,
      0,
      center + cutoutRadius + 10,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
