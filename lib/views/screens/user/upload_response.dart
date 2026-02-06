import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/upload_proof_provider.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/nav.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';
import 'package:goldexia_fx/views/screens/user/user_dashboard_screen.dart';
import 'package:goldexia_fx/views/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class UploadResponse extends StatelessWidget {
  const UploadResponse({super.key});

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<ProofUploadsProvider>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                padding: const EdgeInsets.all(16),
                child: Icon(Icons.check, color: AppColors.primary, size: 60),
              ),
              const SizedBox(height: 22),
              Text(
                AppStrings.yourDocumentsUploadedSuceess,
                textAlign: TextAlign.center,
                style: AppTextStyles.s20M.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 10),
              Text(
                AppStrings.wellWellNotify,
                textAlign: TextAlign.center,
                style: AppTextStyles.s15M.copyWith(color: AppColors.white70),
              ),
              const SizedBox(height: 85),
              CustomButton(
                onTap: () async {
                  await provider.fetchProofs();
                  Nav.offAll(const UserDashboardScreen());
                },
                title: AppStrings.ok,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
