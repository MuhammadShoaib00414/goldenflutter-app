import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/upload_image_provider.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';
import 'package:provider/provider.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UploadImageProvider>(context, listen: false);

    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: AppColors.black,
        border: Border.all(color: AppColors.primerColorThree),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                provider.pickImage(1);
              },
              child: Center(
                child: provider.imageTwo == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 40, color: AppColors.white),
                          Text(
                            AppStrings.addAccountScreenShot,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.s13M.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      )
                    : Image.file(provider.imageTwo!, fit: BoxFit.contain),
              ),
            ),
          ),
          VerticalDivider(color: AppColors.primary),
          Expanded(
            child: InkWell(
              onTap: () {
                provider.pickImage(0);
              },
              child: Center(
                child: provider.imageOne == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 40, color: AppColors.white),
                          Align(
                            child: Text(
                              AppStrings.addDepositScreenShot,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.s13M.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Image.file(provider.imageOne!, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
