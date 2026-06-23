import 'package:aunjai/pages/message.dart';
import 'package:aunjai/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Fixed: Keep MyApp stateless to avoid any State type conflicts!
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _activeTabIndex = 0; // The source of truth for the screen selection

  final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text("แจ้งเตือน", style: TextStyle(color: Colors.white, fontSize: 24))),
    const Center(child: Text("ประวัติ", style: TextStyle(color: Colors.white, fontSize: 24))),
    const Center(child: Text("โปรไฟล์", style: TextStyle(color: Colors.white, fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AunJai AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff080d1a),
      ),
      // Set the shell frame, pass state data, and execute setState when clicked!
      home: MainScreenHolder(
        currentIndex: _activeTabIndex,
        onTabSelected: (index) {
          setState(() {
            _activeTabIndex = index; // This forces the app to rebuild with the selected tab!
          });
        },
        child: IndexedStack(
          index: _activeTabIndex,
          children: _pages,
        ),
      ),
      routes: {
        '/message': (context) => Message()
      }
    );
  }
}

// ==========================================
// 1. MAIN SCREEN HOLDER (PERSISTENT NAVIGATION)
// ==========================================
class MainScreenHolder extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onTabSelected; // 👈 Callback to notify parent when tabs change

  const MainScreenHolder({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xff080d1a),
      body: Stack(
        children: [
          // Top-Right Localized Circle Glow
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xff0ea5e9).withValues(alpha: 0.65),
                    const Color(0xff0ea5e9).withValues(alpha: 0.45),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Bottom Central Localized Circle Glow (Purple)
          Positioned(
            bottom: 0,
            left: screenWidth / 2 - 200,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffa855f7).withValues(alpha: 0.40),
                    const Color(0xffa855f7).withValues(alpha: 0.10),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Reusable Content View
          Positioned.fill(
            child: child,
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final bool isActive = currentIndex == index;
    final Color itemColor = isActive ? Color(0xff3E8BFF) : Colors.white.withValues(alpha: 0.4);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabSelected(index), // 👈 Send the clicked index up to the parent!
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: itemColor, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: itemColor,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      height: 70 + bottomPadding,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipPath(
            clipper: BottomNavClipper(),
            child: Container(
              width: double.infinity,
              height: 58 + bottomPadding,
              decoration: BoxDecoration(
                color: const Color(0xff0d1527),
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.06), width: 1),
                ),
              ),
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(context, Icons.home_outlined, "หน้าหลัก", 0),
                  _buildNavItem(context, Icons.notifications_none, "แจ้งเตือน", 1),
                  const SizedBox(width: 68),
                  _buildNavItem(context, Icons.access_time, "ประวัติ", 2),
                  _buildNavItem(context, Icons.person_outline, "โปรไฟล์", 3),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: bottomPadding + 8,
            child: GestureDetector(
              onTap: () => print("Shield clicked!"),
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xff4d3bf2), Color(0xff3124a8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff4d3bf2).withValues(alpha: 0.35),
                      blurRadius: 14,
                      spreadRadius: 1,
                    )
                  ],
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                ),
                child: const Center(
                  child: Icon(Icons.shield, color: Colors.white, size: 26),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. DATA MODELS & CLIPPERS
// ==========================================
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
    double cutoutRadius = 42.0;
    double center = size.width / 2;

    path.lineTo(center - cutoutRadius - 10, 0);
    path.quadraticBezierTo(
      center - cutoutRadius,
      0,
      center - cutoutRadius + 5,
      12,
    );
    path.arcToPoint(
      Offset(center + cutoutRadius - 5, 12),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
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
