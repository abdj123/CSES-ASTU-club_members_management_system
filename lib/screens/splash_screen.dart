import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:club_members_management_system/admin/admin_landing_page.dart';
import 'package:club_members_management_system/screens/auth/login.dart';
import 'package:club_members_management_system/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../shared_preferance/shared_preference.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool isLoggedIn;
  late bool isAdmin;
  @override
  void initState() {
    isLoggedIn = UserPreferences.getLogin() ?? false;
    isAdmin = UserPreferences.getRole() ?? false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Image.asset("assets/csec.jpg",
            height: MediaQuery.sizeOf(context).height / 3,
            width: MediaQuery.sizeOf(context).width / 2),
        duration: 3000,
        curve: Curves.easeInOut,
        splashIconSize: 350,
        splashTransition: SplashTransition.slideTransition,
        animationDuration: const Duration(milliseconds: 1500),
        backgroundColor: Colors.black,
        // Colors.white,
        pageTransitionType: PageTransitionType.fade,
        nextScreen: isLoggedIn
            ? isAdmin
                ? const AdminLanding()
                : const Landing()
            : const LogIn(),
      ),
    );
  }
}
