import 'package:flutter/material.dart';
import 'package:goldexia_fx/services/local_db/local_storage.dart';
import 'package:goldexia_fx/services/local_db/user_session.dart';
import 'package:goldexia_fx/services/notification/notification_service.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/logs.dart';
import 'package:goldexia_fx/utils/nav.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';
import 'package:goldexia_fx/views/screens/auth/login_screen.dart';
import 'package:share_plus/share_plus.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isNotificationEnabled = false;

  bool get isNotificationEnabled => _isNotificationEnabled;

  ProfileProvider() {
    _loadNotificationState();
  }

  void _loadNotificationState() {
    final localStorage = LocalStorageService.instance;
    _isNotificationEnabled = localStorage.isNotificationEnabled;
    notifyListeners();
  }

  Future<void> toggleNotification(bool value) async {
    _isNotificationEnabled = value;
    final localStorage = LocalStorageService.instance;
    await localStorage.setNotificationEnabled(value);

    // Initialize or deinitialize notification service based on the toggle
    if (value) {
      Log.d('Notifications enabled - initializing notification service');
      await NotificationService.initialize(true);
    } else {
      Log.d('Notifications disabled');
    }

    notifyListeners();
  }

  Future<void> logoutUser(BuildContext context) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.primary,
          insetPadding: const EdgeInsets.all(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.darkBlackColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.confirm,
                  style: AppTextStyles.s18M.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteDark,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppStrings.areyouwanttologout,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.s15M.copyWith(color: AppColors.gray),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.white,
                          side: const BorderSide(color: AppColors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Nav.back();
                        },
                        child: Text(AppStrings.cancel),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.whiteDark,
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          LocalStorageService.instance.clear();
                          await UserSession.logoutUser();
                          Nav.off(LoginScreen());
                        },
                        child: Text(AppStrings.logout),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void shareApp() async {
    const String appLink =
        'https://play.google.com/store/apps/details?id=com.goldexia_fx';
    const String message =
        'Check out this amazing app — Goldexia FX! Download it here:\n$appLink';
    await SharePlus.instance.share(
      ShareParams(text: message, subject: 'Goldexia FX App'),
    );
  }
}
