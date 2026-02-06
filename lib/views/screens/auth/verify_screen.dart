import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/app_providers.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/utils.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key, this.isForgot = false});

  final bool isForgot;
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController otpTec = TextEditingController();
  void sumbit() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    authProvider.verifyOTPForEmail(otpTec.text, widget.isForgot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppAssets.logo, width: 100, height: 100),
                const SizedBox(height: 50),

                Text(
                  AppStrings.verifyEmailAdress,
                  style: AppTextStyles.s18M.copyWith(
                    color: AppColors.white,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                Text(
                  AppStrings.otp,
                  style: AppTextStyles.s15M.copyWith(
                    color: Colors.grey[400],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                CustomTextField(
                  controller: otpTec,
                  validator: (validate) {
                    if (validate == null ||
                        validate.isEmpty ||
                        validate.length < 4) {
                      return AppStrings.optValidate;
                    }
                    return null;
                  },
                  label: AppStrings.otpCode,
                  keyboardtype: TextInputType.number,
                ),
                const SizedBox(height: 50),

                CustomButton(onTap: sumbit, title: AppStrings.verify),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppStrings.didnot, style: AppTextStyles.sw600),
                    TextButton(
                      onPressed: authProvider.sendEmailOTP,
                      child: Text(
                        AppStrings.resend,
                        style: AppTextStyles.sw600.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
