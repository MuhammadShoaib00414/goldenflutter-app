import 'package:flutter/material.dart';
import 'package:goldexia_fx/models/api_response.dart';
import 'package:goldexia_fx/providers/links_provider.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';
import 'package:goldexia_fx/views/screens/user/links_screen.dart';
import 'package:goldexia_fx/views/widgets/qr_popup.dart';
import 'package:goldexia_fx/views/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LinksProvider>(context, listen: false).getSubscriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final linksProvider = context.watch<LinksProvider>();
    final status = linksProvider.subscriptions.status;
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.transparent),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child:  Builder(
        builder: (context) {
          if (status == ResStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Consumer<LinksProvider>(
                  builder: (context, value, child) {
                    final data = value.subscriptions.data ?? [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data.map((e) {
                        final isSelected =
                            e.id == value.selectedSubscription?.id;
                        return SubscriptionTile(
                          subscription: e,
                          onTap: () => value.selectSubscription(e),
                          isSelected: isSelected,
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              SizedBox(height: 135,),
              CustomButton(
                onTap: () {
                  final selected = linksProvider.selectedSubscription;
                  if (selected != null) {
                    showDialog(
                      context: context,
                      builder: (context) => QrPopUp(subscription: selected),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(AppStrings.pleaseSelectSubscription),
                      ),
                    );
                  }
                },
                title: AppStrings.buy,
              ),
              const SizedBox(height: 15),
              Text(
               AppStrings.pleaseUploadPaidPackageFee,
                style: AppTextStyles.s16M.copyWith(color: AppColors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    ),
  );
}
}