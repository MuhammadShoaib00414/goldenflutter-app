import 'package:flutter/material.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.onTap,
    this.child,
    this.padding,
    this.height,
    this.width,
    this.icon,
  });
  final void Function()? onTap;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? 0, height ?? 0),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        padding: padding ?? EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      label: child!,
      icon: icon,
    );
  }
}
