import 'package:aunjai/pages/check/image/upload.dart';
import 'package:aunjai/pages/check/result.dart';
import 'package:aunjai/pages/menu/history.dart';
import 'package:aunjai/pages/check/image/result.dart';
import 'package:aunjai/pages/check/link.dart';
import 'package:aunjai/pages/login.dart';
import 'package:aunjai/pages/check/message.dart';
import 'package:aunjai/pages/home.dart';
import 'package:aunjai/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 1. Define a Global Navigation Key to track app context state safely
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    // 1. The ShellRoute wraps EVERYTHING except login/register so they share the exact same background & navbar layout
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        // 🎯 Pass the active string path location down into the container frame
        return MainScreenHolder(
          currentLocation: state.matchedLocation,
          child: child,
        );
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
        GoRoute(path: '/notifications', builder: (context, state) => Center(child: Text("Notification"))),
        GoRoute(path: '/history', builder: (context, state) => const History()),
        GoRoute(path: '/profile', builder: (context, state) => const Center(child: Text("Profile"))),

        // 🎯 These are now inside the shell layout, so they get the same navbar and background background,
        // but because they aren't part of the main tabs, they will automatically deselect all icons!
        GoRoute(path: '/message', builder: (context, state) => const Message()),
        GoRoute(path: '/image/upload', builder: (context, state) => const ImageUploadPage()),
        GoRoute(path: '/image/result', builder: (context, state) => const ImageCheckPage()),
        GoRoute(path: '/link', builder: (context, state) => const LinkCheck()),
        GoRoute(path: '/result', builder: (context, state) => const ResultPage()),
      ],
    ),

    // 2. Login & Register completely outside (different layouts entirely)
    GoRoute(
      path: '/register',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LogInPage(),
    ),
  ],
);

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AunJai AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff080d1a),
        fontFamily: 'IBM'
      ),
      routerConfig: _router,
    );
  }
}

// ==========================================
// 1. MAIN SCREEN HOLDER (PERSISTENT NAVIGATION)
// ==========================================
class MainScreenHolder extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const MainScreenHolder({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // Your shared background glow designs live here globally...

            // The active page content
            Positioned.fill(child: child),

            // Shared Bottom Nav Bar Layout Dock
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomNavigationBar(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ClipPath(
          clipper: BottomNavClipper(),
          child: Container(
            height: 70,
            color: const Color(0xff0d152d),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 🎯 Ensure this doesn't have an "|| currentLocation == '/message'" or a default true fallback!
                _buildTabItem(
                  context,
                  icon: Icons.home_outlined,
                  label: "หน้าหลัก",
                  targetPath: '/home',
                ),
                _buildTabItem(
                  context,
                  icon: Icons.notifications_none_outlined,
                  label: "แจ้งเตือน",
                  targetPath: '/notifications',
                ),

                const SizedBox(width: 48), // Space for floating button

                _buildTabItem(
                  context,
                  icon: Icons.access_time,
                  label: "ประวัติ",
                  targetPath: '/history',
                ),
                _buildTabItem(
                  context,
                  icon: Icons.person_outline,
                  label: "โปรไฟล์",
                  targetPath: '/profile',
                ),
              ],
            ),
          ),
        ),
        // Floating Shield Middle Button
        Positioned(
          top: 0,
          child: GestureDetector(
            onTap: () =>
                context.go('/image'), // Example target path route execution
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xff4f46e5), Color(0xff3730a3)],
                ),
              ),
              child: const Icon(Icons.shield, color: Colors.white, size: 26),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String targetPath,
  }) {
    // 🎯 CRITICAL CONDITION: Directly matches current exact string path.
    // If accessing sub-pages like /image or /message, this evaluates to false across all items,
    // automatically dropping all highlights to unselected colors!
    final bool isSelected = currentLocation == targetPath;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          context.go(targetPath);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            // Lights up when active, dims to 40% opacity when on sub-pages like /message
            color: isSelected
                ? Colors.blueAccent
                : Colors.white.withValues(alpha: 0.4),
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.blueAccent
                  : Colors.white.withValues(alpha: 0.4),
              fontSize: 14,
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
