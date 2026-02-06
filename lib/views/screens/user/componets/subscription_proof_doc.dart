import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/upload_image_provider.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/nav.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';
import 'package:goldexia_fx/views/screens/user/upload_response.dart';
import 'package:goldexia_fx/views/widgets/custom_button.dart';
import 'package:goldexia_fx/views/widgets/second_container.dart';
import 'package:provider/provider.dart';

class SubscriptionProofDocScreen extends StatefulWidget {
  const SubscriptionProofDocScreen({super.key});

  @override
  State<SubscriptionProofDocScreen> createState() =>
      _SubscriptionProofDocScreenState();
}

class _SubscriptionProofDocScreenState
    extends State<SubscriptionProofDocScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<UploadImageProvider>(context, listen: false);
   final provider = context.watch<UploadImageProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 6),
                  Center(
                    child: Text(
                      AppStrings.subscriptionScreenDiscription,
                      style: AppTextStyles.s13M.copyWith(
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 60),

                  Center(
                    child:  SecondContainer(),
                  ),
                  SizedBox(height: 140),
                  Center(
                    child: CustomButton(
                      onTap: () async {
                        // 
                        bool isUploaded = await provider
                            .uploadsProofsOfSubscription();
                        if (isUploaded) {
                          Nav.to(UploadResponse());

                          provider.removeImage();
                        }
                      },
                      title: AppStrings.uploadDocument,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
