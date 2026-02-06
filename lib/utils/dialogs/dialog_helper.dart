import 'package:flutter/material.dart';
import 'package:goldexia_fx/views/widgets/custom_button.dart';

import '../utils.dart';

class DialogHelper {
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    Widget? icon,
    String positiveButtonText = 'Yes',
    String negativeButtonText = 'No',
    VoidCallback? onPositivePressed,
    VoidCallback? onNegativePressed,
    bool isDismissible = true,
    bool showNegativeButton = true,
    Color? positiveButtonColor,
    Color? iconBackgroundColor,
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: AppColors.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Container (if icon provided)
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          iconBackgroundColor ??
                          AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: icon,
                  ),
                  const SizedBox(height: 20),
                ],

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.white.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    // Negative Button
                    if (showNegativeButton)
                      Expanded(
                        child: CustomOutlinedButton(
                          // height: SizeConfig.heightMultiplier * 5.5,
                          onPressed: () {
                            Navigator.of(dialogContext).pop(false);
                            onNegativePressed?.call();
                          },
                          text: negativeButtonText,
                        ),
                      ),
                    const SizedBox(width: 12),

                    // Positive Button
                    Expanded(
                      child: CustomButton(
                        // height: SizeConfig.heightMultiplier * 5.5,
                        title: positiveButtonText,
                        bgColor: positiveButtonColor ?? AppColors.primary,
                        onTap: () {
                          Navigator.of(dialogContext).pop(true);
                          onPositivePressed?.call();
                        },
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

  static Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    required String message,
    Widget? icon,
    String buttonText = 'OK',
    VoidCallback? onPressed,
    bool isDismissible = true,
    Color? buttonColor,
    Color? iconBackgroundColor,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: AppColors.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Container (if icon provided)
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          iconBackgroundColor ??
                          AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: icon,
                  ),
                  const SizedBox(height: 20),
                ],

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.white.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    title: buttonText,
                    bgColor: buttonColor ?? AppColors.primary,
                    onTap: () {
                      Navigator.of(dialogContext).pop();
                      onPressed?.call();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show a loading dialog with custom message
  ///
  /// Parameters:
  /// - [context]: BuildContext for showing the dialog
  /// - [message]: Loading message (default: "Please wait...")
  ///
  /// Returns: Dialog context for dismissing later

  static Future<void> showLoadingDialog({
    required BuildContext context,
    String message = 'Please wait...',
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: AppColors.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Dismiss the currently showing dialog
  static void dismissDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
