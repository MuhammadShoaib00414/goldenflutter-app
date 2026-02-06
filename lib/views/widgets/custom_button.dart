import 'package:flutter/material.dart';
import 'package:goldexia_fx/utils/utils.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.title,
    this.bgColor,
  });
  final void Function() onTap;
  final String title;
  final Color? bgColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.white,
        backgroundColor: bgColor ?? AppColors.primary,
        minimumSize: Size(325, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(title, style: AppTextStyles.s14M),
    );
  }
}

class AppIconBtn extends StatelessWidget {
  const AppIconBtn(
    this.iconData, {
    super.key,
    this.color,
    this.size,
    this.onTap,
  });
  final Color? color;
  final double? size;
  final void Function()? onTap;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(iconData, size: size, color: color ?? AppColors.primary),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final double? fontSize;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        side: BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: Size(width ?? double.infinity, height ?? 50),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
