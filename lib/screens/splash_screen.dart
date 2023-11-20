import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:club_members_management_system/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Image.asset("assets/csec.png",
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
        nextScreen: const HomePage(),
      ),
    );
  }
}
