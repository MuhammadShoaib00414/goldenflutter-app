import 'package:flutter/material.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/utils.dart';
import 'package:goldexia_fx/views/screens/admin/admin_dashboard_screen.dart';
import 'package:goldexia_fx/views/screens/on_boarding_screen.dart';
import 'package:goldexia_fx/views/screens/user/user_dashboard_screen.dart';
import 'package:goldexia_fx/views/screens/welcome_screen.dart';

import '../../services/local_db/local_storage.dart';
import '../../services/local_db/user_session.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final res = await UserSession.getUser();
    Widget homeScreen;
    if (res == null||res.accessToken == null) {
      homeScreen = WelcomeScreen(); 
    } else {
      final localStorage = LocalStorageService.instance;
      if (res.user?.role == 'user') {
        final isOnboardingCompleted = localStorage.isOnboardingCompleted;
        if (isOnboardingCompleted) {
          homeScreen = UserDashboardScreen();
        } else {
          homeScreen = OnBoardingScreen();
        }
      } else {
        homeScreen = AdminDashboardScreen();
      }
    }
    Future.delayed(Duration(seconds: 2), () {
      Nav.offAll(homeScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgrounColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppAssets.logo, height: 200, width: 200),
            SizedBox(height: 10),
            Text(
              AppStrings.gold,
              style: AppTextStyles.splashAppNameStyle.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
