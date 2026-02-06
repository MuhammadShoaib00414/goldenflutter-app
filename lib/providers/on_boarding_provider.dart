import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OnBoardingProvider extends ChangeNotifier {
  final PageController controller = PageController();
  int currentIndex = 0;

  void onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void nextPage(int totalPages) {
    if (currentIndex < totalPages - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToEnd(int totalPages) {
    controller.jumpToPage(totalPages - 1);
  }

 Future<void> openWhatsApp() async {
 

  try {
    final Uri uri = Uri.parse('https://wa.me/message/OZA3JRVNIHD2I1');

    // Try direct open first
    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      return;
    }

    // 🔁 Fallback: open in browser if direct launch fails
    if (await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
      return;
    }

    debugPrint('❌ Could not launch: $uri');
  } catch (e) {
    debugPrint('⚠️ Invalid URL: $e');
  }
 }
}
