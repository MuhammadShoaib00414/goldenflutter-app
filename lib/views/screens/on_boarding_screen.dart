import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/on_boarding_provider.dart';
import 'package:goldexia_fx/utils/utils.dart';
import 'package:goldexia_fx/views/screens/user/user_dashboard_screen.dart';
import 'package:goldexia_fx/views/widgets/custom_elevated.dart';
import 'package:provider/provider.dart';

import '../../models/pageview_builder/pageview_model.dart';
import '../../services/local_db/local_storage.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  Future<void> completeOnBoardingScreen(BuildContext context) async {
    final localStorage = LocalStorageService.instance;
    await localStorage.setOnboardingCompleted(true);
    Nav.offAll(UserDashboardScreen());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<OnBoardingProvider>(
      builder: (context, onBoardingProvider, _) {
        final pages = InfoPageModel.pages;

        return Scaffold(
          body: Stack(
            children: [
              // Background gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.05),
                      Colors.transparent,
                      AppColors.primary.withValues(alpha: 0.03),
                    ],
                  ),
                ),
              ),

              Column(
                children: [
                  // ---------- PAGE VIEW ----------
                  Expanded(
                    child: PageView.builder(
                      controller: onBoardingProvider.controller,
                      onPageChanged: onBoardingProvider.onPageChanged,
                      itemCount: pages.length,
                      itemBuilder: (context, index) {
                        final page = pages[index];

                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: size.height * 0.08),

                                // ---------- ICON CONTAINER ----------
                                _buildIconContainer(page.title),

                                SizedBox(height: size.height * 0.04),

                                // ---------- TITLE ----------
                                Text(
                                  _extractTitle(page.title),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.s24b.copyWith(
                                    color: AppColors.primary,
                                    letterSpacing: 0.8,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // ---------- DESCRIPTION ----------
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    page.description,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.s16M.copyWith(
                                      color: AppColors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      height: 1.7,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),

                                SizedBox(height: size.height * 0.03),

                                // ---------- BULLETS CARD ----------
                                if (page.bullets != null)
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withValues(
                                        alpha: 0.05,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.1,
                                          ),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: page.bullets!
                                          .map(
                                            (text) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                          top: 4,
                                                        ),
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary
                                                          .withValues(
                                                            alpha: 0.2,
                                                          ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Container(
                                                      width: 6,
                                                      height: 6,
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: AppColors
                                                                .primary,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (onBoardingProvider
                                                                .currentIndex ==
                                                            pages.length - 1) {
                                                          onBoardingProvider
                                                              .openWhatsApp();
                                                        }
                                                      },
                                                      child: Text.rich(
                                                        TextSpan(
                                                          text: text,
                                                          style: AppTextStyles.s15M.copyWith(
                                                            color:
                                                                (onBoardingProvider
                                                                        .currentIndex ==
                                                                    pages.length -
                                                                        1)
                                                                ? AppColors.blue
                                                                : AppColors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.95,
                                                                      ),
                                                            decoration:
                                                                (onBoardingProvider
                                                                        .currentIndex ==
                                                                    pages.length -
                                                                        1)
                                                                ? TextDecoration
                                                                      .underline
                                                                : TextDecoration
                                                                      .none,

                                                            height: 1.6,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),

                                SizedBox(height: size.height * 0.03),

                                // ---------- FOOTER ----------
                                if (page.footer != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primary.withValues(
                                            alpha: 0.08,
                                          ),
                                          AppColors.primary.withValues(
                                            alpha: 0.03,
                                          ),
                                        ],
                                      ),
                                    ),
                                    child: Text(
                                      page.footer!,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.s14M.copyWith(
                                        color: AppColors.white.withValues(
                                          alpha: 0.75,
                                        ),
                                        height: 1.6,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),

                                SizedBox(height: size.height * 0.02),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // ---------- INDICATORS & BUTTONS ----------
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.3),
                      border: Border(
                        top: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ---------- SKIP ----------
                        TextButton(
                          onPressed: () =>
                              onBoardingProvider.skipToEnd(pages.length),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: Text(
                            "Skip",
                            style: AppTextStyles.s16M.copyWith(
                              color: AppColors.white.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // ---------- INDICATORS ----------
                        Row(
                          children: List.generate(
                            pages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: onBoardingProvider.currentIndex == index
                                  ? 10
                                  : 8,
                              width: onBoardingProvider.currentIndex == index
                                  ? 28
                                  : 8,
                              decoration: BoxDecoration(
                                color: onBoardingProvider.currentIndex == index
                                    ? AppColors.primary
                                    : AppColors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow:
                                    onBoardingProvider.currentIndex == index
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.4,
                                          ),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          ),
                        ),

                        // ---------- NEXT / START ----------
                        CustomElevatedButton(
                          onTap: () {
                            if (onBoardingProvider.currentIndex ==
                                pages.length - 1) {
                              completeOnBoardingScreen(context);
                            } else {
                              onBoardingProvider.nextPage(pages.length);
                            }
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                onBoardingProvider.currentIndex ==
                                        pages.length - 1
                                    ? "Get Started"
                                    : "Next",
                                style: AppTextStyles.s16M.copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // const SizedBox(width: 3),
                              // Icon(
                              //   onBoardingProvider.currentIndex == pages.length - 1
                              //       ? Icons.rocket_launch
                              //       : Icons.arrow_forward,
                              //   color: AppColors.black,
                              //   size: 18,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to extract icon emoji from title
  String _extractEmoji(String title) {
    final emojiMatch = RegExp(
      r'[\u{1F300}-\u{1F9FF}]',
      unicode: true,
    ).firstMatch(title);
    return emojiMatch?.group(0) ?? '✨';
  }

  // Helper method to extract title without emoji
  String _extractTitle(String title) {
    return title
        .replaceAll(RegExp(r'[\u{1F300}-\u{1F9FF}]', unicode: true), '')
        .trim();
  }

  // Build attractive icon container
  Widget _buildIconContainer(String title) {
    final emoji = _extractEmoji(title);

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.primary.withValues(alpha: 0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 56))),
    );
  }
}
