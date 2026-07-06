import 'package:aunjai/pages/check/call/result.dart';
import 'package:aunjai/pages/check/image/upload.dart';
import 'package:aunjai/pages/check/result.dart';
import 'package:aunjai/pages/login/resetpw.dart';
import 'package:aunjai/pages/menu/history.dart';
import 'package:aunjai/pages/check/image/result.dart';
import 'package:aunjai/pages/check/link.dart';
import 'package:aunjai/pages/login/login.dart';
import 'package:aunjai/pages/check/message.dart';
import 'package:aunjai/pages/check/news.dart';
import 'package:aunjai/pages/check/call/questionaire.dart';
import 'package:aunjai/pages/home.dart';
import 'package:aunjai/pages/login/register.dart';
import 'package:aunjai/pages/menu/notification.dart';
import 'package:aunjai/pages/menu/profile.dart';
import 'package:aunjai/pages/menu/setting.dart';
import 'package:aunjai/pages/report.dart';
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
        GoRoute(path: '/notifications', builder: (context, state) => NotificationPage()),
        GoRoute(path: '/history', builder: (context, state) => const History()),
        GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
        GoRoute(path: '/settings', builder: (context, state) => const SettingsPage()),

        // 🎯 These are now inside the shell layout, so they get the same navbar and background background,
        // but because they aren't part of the main tabs, they will automatically deselect all icons!
        GoRoute(path: '/message', builder: (context, state) => const Message()),
        GoRoute(path: '/call/questionaire', builder: (context, state) => const CallMode()),
        GoRoute(
          path: '/call/result', 
          builder: (context, state) {
            // Cast the extra parameter back into a Map
            final risks = state.extra as Map<String, double>;
            
            return CallResultPage(
              actionRisk: risks['actionRisk'] ?? 0.0,
              identityRisk: risks['identityRisk'] ?? 0.0,
              contextRisk: risks['contextRisk'] ?? 0.0
            );
          }
        ),
        GoRoute(path: '/image/upload', builder: (context, state) => const ImageUploadPage()),
        GoRoute(path: '/image/result', builder: (context, state) => const ImageCheckPage()),
        GoRoute(path: '/link', builder: (context, state) => const LinkCheck()),
        GoRoute(path: '/news', builder: (context, state) => const NewsCheck()),
        GoRoute(path: '/report', builder: (context, state) => const ReportPage()),
        GoRoute(
          path: '/result', 
          builder: (context, state) {
            // Cast the extra parameter back into a Map
            final risks = state.extra as Map<String, double>;
            
            return ResultPage(
              actionRisk: risks['actionRisk'] ?? 0.0,
              identityRisk: risks['identityRisk'] ?? 0.0,
              contextRisk: risks['contextRisk'] ?? 0.0
            );
          }
        ),
      ],
    ),

    // 2. Login & Register completely outside (different layouts entirely)
    GoRoute(path: '/register', parentNavigatorKey: _rootNavigatorKey, builder: (context, state) => const RegisterPage()),
    GoRoute(path: '/login', parentNavigatorKey: _rootNavigatorKey, builder: (context, state) => const LogInPage()),
    GoRoute(path: '/resetpw', parentNavigatorKey: _rootNavigatorKey, builder: (context, state) => const ResetPWPage()),
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
    const pageBackground = Color(0xff091026); // Background color of your page gradient container
    const navBarBackground = Color(0xff0d152d); // Dark navigation bar color

    return Container(
      height: 76, // 🎯 Reduced overall wrapper height to pull the button down
      color: Colors.transparent, 
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // 1. The Main Solid Navigation Bar Row
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 64,
              decoration: const BoxDecoration(
                color: navBarBackground,
                border: Border(
                  top: BorderSide(color: Colors.white10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
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

                  const SizedBox(width: 56), // Matches the shield layout span cleanly

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

          // 2. The Overlapping Shield Button (Shifted down)
          Positioned(
            top: 4, // 🎯 Shifted down from 0 to eliminate that empty gap look
            child: GestureDetector(
              onTap: () => context.go('/call/questionaire'), //
              child: Container(
                width: 64, // Matches original specifications
                height: 64, //
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: pageBackground, 
                    width: 4,
                  ),
                  gradient: const LinearGradient(
                    colors: [Color(0xff2563eb), Color(0xff7c3aed)], //
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff7c3aed).withValues(alpha: 0.25),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const Icon(Icons.shield, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
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
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 50
        ),
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
        )
      )
    );
  }
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
