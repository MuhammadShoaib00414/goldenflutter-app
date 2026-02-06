import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle s20M = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const title = TextStyle(fontWeight: FontWeight.bold);

  static const appBarText = TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static const s24b = TextStyle(
    color: Colors.black87,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );
 

  static const s13M = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
 
  static const s14N = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.blue,
  );
  static const s14M = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );
  static const errorTextStyle = TextStyle(
    fontSize: 12, // smaller error font
    height: 0.8, // less vertical space
    color: Colors.redAccent,
  );
  static const sw600 = TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.w600,
  );
  static const s28M = TextStyle(
    fontSize: 28,
    color: AppColors.white,
    fontWeight: FontWeight.w700,
  );
  static const s15M = TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
  static const s15N = TextStyle(fontSize: 15, color: AppColors.brandDarkBlue);
  static const s16M = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const s17M = TextStyle(fontSize: 17, fontWeight: FontWeight.w600);
  static const s18M = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const s26M = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const subTitle = TextStyle(color: AppColors.gray);
 

  static const splashAppNameStyle = TextStyle(
    color: AppColors.white,
    fontSize: 35,
    fontWeight: FontWeight.w600,
  );

  static const loaderStyle = TextStyle(
    color: AppColors.primaryText,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

 
}
