import 'package:flutter/material.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/utils.dart';
import 'package:goldexia_fx/views/screens/auth/login_screen.dart';

import '../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
            SizedBox(height: 15),
            Text(
              AppStrings.welcome,
              style: AppTextStyles.s28M.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 45, right: 15, left: 15),
        child: CustomButton(
          onTap: () {
            Nav.off(LoginScreen());
          },
          title: 'Get Started',
        ),
      ),
    );
  }
}
