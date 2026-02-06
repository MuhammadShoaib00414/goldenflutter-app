import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/app_providers.dart';
import 'package:goldexia_fx/providers/login_screen_provider.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/utils.dart';
import 'package:goldexia_fx/views/widgets/custom_text_field.dart'
    show CustomTextField;
import 'package:provider/provider.dart';

import '../../widgets/custom_button.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void sumbit() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    authProvider.updatePassword(passwordController.text);
  }

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isVisible = false;
  bool confirmVisible = false;

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<LoginScreenProvider>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppAssets.logo, width: 100, height: 100),
                const SizedBox(height: 50),
                const Text(AppStrings.setPassword, style: AppTextStyles.s26M),
                const SizedBox(height: 8),
                Text(
                  AppStrings.createPassword,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.s14M.copyWith(
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 30),

                CustomTextField(
                  obscureText:provider. isVisible ? false : true,
                  suffixIcon: IconButton(
                    icon: Icon(
                     provider. isVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                    provider.checkVisible();
                    },
                  ),
                  controller: passwordController,
                  label: AppStrings.newPassword,
                  validator: (validate) {
                    if (validate == null ||
                        validate.isEmpty ||
                        validate.length < 6) {
                      return AppStrings.passwordValidate;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  obscureText:provider. isconfirmVisible ? false : true,
                  suffixIcon: IconButton(
                    icon: Icon(
                    provider.isconfirmVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                     provider.checkConfirmVisible();
                    },
                  ),

                  controller: confirmPasswordController,
                  label: AppStrings.confirmPassword,
                  validator: (validate) {
                    if (validate == null ||
                        validate.isEmpty ||
                        validate != passwordController.text) {
                      return AppStrings.confirmPasswordValidate;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 70),

                CustomButton(onTap: sumbit, title: AppStrings.submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
