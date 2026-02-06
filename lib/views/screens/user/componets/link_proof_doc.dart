


import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/upload_image_provider.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/nav.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';
import 'package:goldexia_fx/views/screens/user/upload_response.dart';
import 'package:goldexia_fx/views/widgets/custom_button.dart';
import 'package:goldexia_fx/views/widgets/custom_text_field.dart';
import 'package:goldexia_fx/views/widgets/image_container.dart';
import 'package:provider/provider.dart';

class LinkProofDocScreen extends StatefulWidget {
  const LinkProofDocScreen({super.key});

  @override
  State<LinkProofDocScreen> createState() => _LinkProofDocScreenState();
}

class _LinkProofDocScreenState extends State<LinkProofDocScreen> {
   TextEditingController accountId = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UploadImageProvider>(context, listen: false);
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
                    Text(
                      AppStrings.linkScreenDiscription,
                      style: AppTextStyles.s13M.copyWith(color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
      
                    SizedBox(height: 28),
                    Form(
                      key: formKey,
                      child: CustomTextField(
                        controller: accountId,
                        label: AppStrings.accountId,
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return AppStrings.thisFieldisRequried;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 35),
                    Center(
                      child: Consumer<UploadImageProvider>(
                        builder: (context, value, child) => ImageContainer(),
                      ),
                    ),
                    SizedBox(height: 85),
                    Center(
                      child: CustomButton(
                        onTap: () async {
                          if (!(formKey.currentState!.validate())) return;
                          bool isUploaded = await provider.uploadsProofs(
                            accountId.text,
                          );
                          if (isUploaded) {
                            Nav.to(UploadResponse());
                            accountId.clear();
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

