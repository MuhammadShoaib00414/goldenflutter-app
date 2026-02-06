import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/on_boarding_provider.dart';
import 'package:goldexia_fx/providers/profile_provider.dart';
import 'package:goldexia_fx/services/local_db/user_session.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/utils.dart';
import 'package:goldexia_fx/views/widgets/custom_list_tile.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnBoardingProvider>(context);
    final proProvider = Provider.of<ProfileProvider>(context);
    final user = UserSession.currentUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.profile,
          style: AppTextStyles.s24b.copyWith(color: AppColors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: const Icon(
                  Icons.person,
                  size: 42,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user?.user?.firstName ?? 'No Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.user?.email ?? 'No Email',
                style: TextStyle(color: Colors.grey.shade600),
              ),
          
              const SizedBox(height: 35),
          
              CustomListTile(
                icon: Icons.help_outline,
                title: AppStrings.helpSupport,
                onTap: () {
                  provider.openWhatsApp();
                },
              ),
              CustomListTile(
                icon: Icons.policy,
                title: AppStrings.pPolicy,
                onTap: () {},
              ),
              CustomListTile(
                icon: Icons.share,
                title: AppStrings.shareApp,
                onTap: proProvider.shareApp,
              ),
              CustomListTile(
                icon: Icons.logout,
                title: AppStrings.logout,
                onTap: () {
                  proProvider.logoutUser(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
