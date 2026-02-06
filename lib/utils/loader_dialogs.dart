import 'package:flutter/material.dart';

import 'nav.dart';
import 'res/app_colors.dart';
import 'res/app_text_styles.dart';

class Loader {
  static bool isLoaderDlgVisible = false;
  static void show({Color? color, String? msg}) {
    isLoaderDlgVisible = true;
    showDialog(
      context: Nav.key.currentState!.context,
      barrierDismissible: false,
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.primary,
            ),
            child: Material(
              color: AppColors.transparent,
              child: Column(
                children: [
                  const CircularProgressIndicator(color: AppColors.white),
                  const SizedBox(height: 15),
                  Text(
                    msg ?? 'Please Wait...',
                    style: AppTextStyles.loaderStyle.copyWith(
                      color: AppColors.whiteDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void hide() {
    if (isLoaderDlgVisible) {
      Navigator.pop(Nav.key.currentState!.context);
    }
    isLoaderDlgVisible = false;
  }
}
