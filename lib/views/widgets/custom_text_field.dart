import 'package:flutter/material.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.label = '',
    this.suffixIcon,
    this.obscureText,
    this.prefixIcon,
    this.keyboardtype,
    this.validator,
    this.onSaved,
    this.controller,
    this.maxLine=1,
    this.hint,
  });
  final int? maxLine;
  final String label;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final TextInputType? keyboardtype;
  final String? Function(String? validate)? validator;
  final String Function(String? value)? onSaved;
  final TextEditingController? controller;
  final String? hint;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLine,
      controller: controller,
      keyboardType: keyboardtype,
      style: AppTextStyles.s16M.copyWith(color: AppColors.white),
      cursorColor: AppColors.primary,
      obscureText: obscureText ?? false,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        errorStyle: AppTextStyles.errorTextStyle,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,

        filled: true,
        fillColor: AppColors.darkBlackColor, // dark background field color
        label: Text(
          label,
          style: AppTextStyles.s13M.copyWith(color: AppColors.white),
        ),
        labelStyle: TextStyle(color: Colors.white54),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.2,
          ), // gold border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primerColorThree,
            width: 1.5,
          ), // brighter gold
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.red, width: 1.8),
        ),
      ),
    );
  }
}
