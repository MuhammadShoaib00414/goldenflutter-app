import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/upload_proof_provider.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/utils.dart';
import 'package:goldexia_fx/views/screens/user/user_dashboard_screen.dart';
import 'package:provider/provider.dart';
class RejectedScreen extends StatelessWidget {
  final String? reason;

  const RejectedScreen({super.key, this.reason});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.red.withValues(alpha: 0.1),
                ),
                child: const Icon(
                  Icons.cancel_outlined,
                  color: AppColors.red,
                  size: 110,
                ),
              ),

              const SizedBox(height: 24),

               Text(
                AppStrings.documentRejected,
                style: AppTextStyles.s20M.copyWith( color: AppColors.white70,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,)
              ),

              const SizedBox(height: 12),

              Text(
                reason ?? AppStrings.submitDocumentRejected,
                textAlign: TextAlign.center,
                style: AppTextStyles.s14M.copyWith(color: Colors.grey.shade600,)
              ),

              const SizedBox(height: 25),

              Text(
                AppStrings.pleaseUploadAgain,
                style: AppTextStyles.s13M.copyWith( color: Colors.grey.shade500)
              ),

              const SizedBox(height: 85),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context
                        .read<ProofUploadsProvider>()
                        .resetProof();

                    Nav.off(UserDashboardScreen());
                  },
                  child: Text(
                    AppStrings.uploadAgain,
                    style: AppTextStyles.s15M.copyWith(fontWeight: FontWeight.w600,)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
