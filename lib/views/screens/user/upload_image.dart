import 'package:flutter/material.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';
import 'package:goldexia_fx/views/screens/user/componets/link_proof_doc.dart';
import 'package:goldexia_fx/views/screens/user/componets/subscription_proof_doc.dart';

// Upload proof Documents
// image input key

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
 
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppStrings.uploadImage,
            style: AppTextStyles.s24b.copyWith(color: AppColors.white),
            textAlign: TextAlign.center,
          ),
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 48,
                
                decoration: BoxDecoration(
                 color: AppColors.white.withValues(alpha:  0.1), // light background for whole tab bar
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                 dividerColor: Colors.transparent, // removes any divider
                  indicator: BoxDecoration(
                    color: AppColors.primary, // selected tab full color
                    borderRadius: BorderRadius.circular(12), // smooth rounded highlight
                  ),
                  indicatorSize: TabBarIndicatorSize.tab, // covers full tab width
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(alpha:  0.8),
                  labelStyle: AppTextStyles.s15M.copyWith(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: AppTextStyles.s15M,
                  tabs: [Text(AppStrings.link), Text(AppStrings.subscription)],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [LinkProofDocScreen(), SubscriptionProofDocScreen()],
        ),
      ),
    );
  }
}
