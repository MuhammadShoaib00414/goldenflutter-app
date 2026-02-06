import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/upload_proof_provider.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/nav.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';
import 'package:goldexia_fx/views/screens/user/user_dashboard_screen.dart';
import 'package:goldexia_fx/views/widgets/custom_elevated.dart';
import 'package:provider/provider.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProofUploadsProvider>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: Tween(begin: 0.95, end: 1.05).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: const Icon(
                    Icons.hourglass_top,
                    size: 72,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  AppStrings.verificationIsProgress,
                  style: AppTextStyles.s20M.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  AppStrings.yourDocumentsAreReview,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.s14M.copyWith(color: AppColors.white70),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    AppStrings.youWillBeNotify,
                    style: AppTextStyles.s13M.copyWith(
                      color: AppColors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(height: 22,),
                CustomElevatedButton(
                  onTap: () async {
                    await provider.fetchProofs();
                    Nav.offAll(UserDashboardScreen());
                  },
                  icon: Icon(Icons.refresh),
                  width: 230,
                  child: Text('Refresh'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
