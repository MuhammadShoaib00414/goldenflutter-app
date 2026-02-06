import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/upload_image_provider.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';
import 'package:provider/provider.dart';

class SecondContainer extends StatefulWidget {
  const SecondContainer({super.key});

  @override
  State<SecondContainer> createState() => _SecondContainerState();
}

class _SecondContainerState extends State<SecondContainer> {
  @override
  Widget build(BuildContext context) {
   // final provider = Provider.of<UploadImageProvider>(context,);
    final provider = context.watch<UploadImageProvider>();

    return InkWell(
      onTap: () {
        provider.imagePicker();
      },
      child: Container(
        height: 240,
        width: 350,
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
        child: Center(
          child: provider.picture == null
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
              : Image.file(provider.picture!, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
