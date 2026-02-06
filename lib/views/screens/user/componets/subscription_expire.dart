import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/upload_proof_provider.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/utils.dart';
import 'package:goldexia_fx/views/screens/user/user_dashboard_screen.dart';
import 'package:goldexia_fx/views/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class SubscriptionExpiredScreen extends StatelessWidget {
  const SubscriptionExpiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<ProofUploadsProvider>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_clock, size: 60, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                AppStrings.subscriptionExpired,

                textAlign: TextAlign.center,
                style:AppTextStyles.s16M.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 180),
              CustomButton(
                onTap: () {
                  provider.resetProof();
                  Nav.off(UserDashboardScreen());
                },
                title: AppStrings.renewSubscription,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
