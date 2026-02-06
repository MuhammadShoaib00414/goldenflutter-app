import 'package:flutter/material.dart';
import 'package:goldexia_fx/models/link.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/app_utils.dart';
import 'package:goldexia_fx/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/subscription.dart';

class LinksScreen extends StatelessWidget {
  const LinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.link,
          style: AppTextStyles.s24b.copyWith(color: AppColors.white),
          textAlign: TextAlign.center,
        ),

        backgroundColor: AppColors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...LinkItem.items.map((e) => LinkCard(item: e)),
              const SizedBox(height: 10),
              Text(
                'please Upload your account number and deposit details once you make trading account through our link in upload document section',
                style: AppTextStyles.s16M.copyWith(color: AppColors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable Custom Widget for the Cards
class LinkCard extends StatelessWidget {
  final LinkItem item;

  const LinkCard({super.key, required this.item});

  // void _copyToClipboard(BuildContext context) {
  //   Clipboard.setData(ClipboardData(text: item.url));
  //   AppUtils.showToast("Link copied: ${item.title}");
  // }

  Future<void> _openUrlInBroswer() async {
    final Uri uri = Uri.parse(item.url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      AppUtils.showToast("Could not open link");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.grey.withValues(alpha: .2),
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: AppTextStyles.appBarText.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              item.description,
              style: AppTextStyles.s14N.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 16),

            // Link Container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _openUrlInBroswer,
                      child: Text(
                        item.url,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // InkWell(
                  //   onTap: () => _copyToClipboard(context),
                  //   child: Container(
                  //     padding: const EdgeInsets.all(8),
                  //     decoration: const BoxDecoration(
                  //       color: AppColors.black,
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: const Icon(
                  //       Icons.copy,
                  //       size: 20,
                  //       color: AppColors.primary,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionTile extends StatelessWidget {
  const SubscriptionTile({
    super.key,
    required this.subscription,
    this.onTap,
    this.isSelected = false,
  });

  final SubscriptionData subscription;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:  8.0),
      child: Material(
         color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(     
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            //margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(child: _buildContent(context)),
                const SizedBox(width: 12),
                _buildPrice(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Title + description + duration
  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subscription.name ?? '',
          style: AppTextStyles.title.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        if (subscription.description?.isNotEmpty == true)
          Text(
            subscription.description!,
            style: AppTextStyles.subTitle.copyWith(
              fontSize: 12,
              color: AppColors.white70,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  /// Price section
  Widget _buildPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          subscription.formattedPrice ?? '',
          style: AppTextStyles.title.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${subscription.durationMonths ?? 0}m',
          style: AppTextStyles.subTitle.copyWith(
            fontSize: 11,
            color: AppColors.white70,
          ),
        ),
      ],
    );
  }
}
