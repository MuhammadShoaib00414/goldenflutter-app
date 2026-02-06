import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../services/local_db/local_storage.dart';
import '../../services/notification/notification_service.dart';
import '../logs.dart';
import '../nav.dart';
import '../res/app_colors.dart';
import 'dialog_helper.dart';

class NotificationPermissionDialog {
  static Future<bool> show() async {
    final result = await DialogHelper.showConfirmationDialog(
      context: Nav.context,
      title: 'Enable Notifications',
      message:
          'Stay updated with important alerts and notifications. We\'ll only send you relevant updates about your GPS photos and app features.',
      icon: _buildNotificationIcon(),
      positiveButtonText: 'Enable',
      negativeButtonText: 'Not Now',
      iconBackgroundColor: AppColors.primary.withValues(alpha: 0.15),
      positiveButtonColor: AppColors.primary,
      isDismissible: true,
      showNegativeButton: true,
      onPositivePressed: () {
        // User accepted, now request actual permission

        _handlePermissionRequest(Nav.context);
      },
      onNegativePressed: () {
        Log.d('User declined notification permission');
        // Save user preference
        LocalStorageService.instance.setNotificationPermissionAsked(true);
        LocalStorageService.instance.setNotificationEnabled(false);
      },
    );

    return result ?? false;
  }

  /// Build notification icon
  static Widget _buildNotificationIcon({double size = 40}) {
    return Icon(
      Icons.notifications_active,
      color: AppColors.primary,
      size: size,
    );
  }

  /// Handle the actual permission request and FCM token retrieval
  static Future<void> _handlePermissionRequest(BuildContext context) async {
    try {
      LocalStorageService.instance.setNotificationPermissionAsked(true);

      // Show loading dialog
      if (context.mounted) {
        DialogHelper.showLoadingDialog(
          context: context,
          message: 'Setting up notifications...',
        );
      }

      // Request notification permission
      final status = await Permission.notification.request();

      if (status.isGranted) {
        Log.success('✅ Notification permission granted');

        // Save permission status
        LocalStorageService.instance.setNotificationEnabled(true);

        // Initialize notification service
        await NotificationService.initialize(true);

        // Get FCM token
        final token = NotificationService.deviceToken;

        if (token != null) {
          Log.success('🔑 FCM Token obtained: $token');

          // Dismiss loading dialog
          if (context.mounted) {
            DialogHelper.dismissDialog(context);
          }
        } else {
          Log.d('⚠️ FCM token is null (might be emulator or no Google Play)');

          // Dismiss loading dialog
          if (context.mounted) {
            DialogHelper.dismissDialog(context);
          }
        }
      } else if (status.isDenied) {
        Log.d('⚠️ Notification permission denied');

        // Dismiss loading dialog
        if (context.mounted) {
          DialogHelper.dismissDialog(context);
        }
      } else if (status.isPermanentlyDenied) {
        Log.d('⚠️ Notification permission permanently denied');

        // Dismiss loading dialog
        if (context.mounted) {
          DialogHelper.dismissDialog(context);
        }

        // Show settings dialog
        if (context.mounted) {
          final shouldOpenSettings = await DialogHelper.showConfirmationDialog(
            context: context,
            title: 'Permission Required',
            message:
                'Notification permission is permanently denied. Please enable it from app settings.',
            icon: const Icon(
              Icons.settings,
              color: AppColors.primary,
              size: 48,
            ),
            positiveButtonText: 'Open Settings',
            negativeButtonText: 'Cancel',
          );

          if (shouldOpenSettings == true) {
            await openAppSettings();
          }
        }
      }
    } catch (e) {
      Log.d('❌ Error requesting notification permission: $e');

      // Dismiss loading dialog
      if (context.mounted) {
        DialogHelper.dismissDialog(context);
      }

      // Show error dialog
      if (context.mounted) {
        await DialogHelper.showInfoDialog(
          context: context,
          title: 'Error',
          message: 'Failed to set up notifications. Please try again later.',
          icon: const Icon(Icons.error_outline, color: AppColors.red, size: 48),
          iconBackgroundColor: AppColors.red.withValues(alpha: 0.15),
          buttonText: 'OK',
          buttonColor: AppColors.red,
        );
      }
    }
  }
}
