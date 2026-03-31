import 'package:flutter/material.dart';
import '../main_navigation/bottom_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    /// ⏳ Navigate after delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        /// 🎨 GRADIENT BACKGROUND
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5B67FF),
              Color(0xFF7C83FD),
              Color(0xFF6A5AE0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Spacer(),

            /// 💎 ICON WITH GLOW
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
              child: const Center(
                child: Icon(
                  Icons.account_balance_wallet,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// 🏷 TITLE
            const Text(
              "Expense Tracker",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            /// 📝 SUBTITLE
            const Text(
              "Track your money smartly",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),

            const Spacer(),

            /// 🔘 DOT INDICATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dot(true),
                dot(false),
                dot(false),
              ],
            ),

            const SizedBox(height: 10),

            /// 🧾 FOOTER TEXT
            const Text(
              "INITIALIZING LEDGER",
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 2,
                color: Colors.white60,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// 🔘 DOT
  static Widget dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 8 : 6,
      height: active ? 8 : 6,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white38,
        shape: BoxShape.circle,
      ),
    );
  }
}