import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/auth_provider.dart';
import 'package:goldexia_fx/providers/login_screen_provider.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/nav.dart';
import 'package:goldexia_fx/utils/res/app_assets.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  void sumbit() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    context.read<AuthProvider>().register(
      nameCtrl.text.trim(),
      emailCtrl.text.trim(),
      passwordCtrl.text.trim(),
    );
  }

  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<LoginScreenProvider>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.logo, height: 120, width: 120),
                  SizedBox(height: 15),
                  Text(
                    AppStrings.signUp,
                    style: AppTextStyles.s24b.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 60),
                  CustomTextField(
                    controller: nameCtrl,
                    validator: (validate) {
                      if (validate == null ||
                          validate.isEmpty ||
                          validate.length < 2) {
                        return AppStrings.usernameValidate;
                      }
                      return null;
                    },
                    label: AppStrings.fullName,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: emailCtrl,
                    validator: (validate) {
                      if (validate == null || validate.isEmpty) {
                        return AppStrings.emailEmpityValidate;
                      }

                      validate = validate.trim();

                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );

                      if (!emailRegex.hasMatch(validate)) {
                        return AppStrings.emailValidate;
                      }
                      return null;
                    },
                    label: AppStrings.email,
                    keyboardtype: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: passwordCtrl,
                    validator: (validate) {
                      if (validate == null ||
                          validate.isEmpty ||
                          validate.length < 6) {
                        return AppStrings.passwordValidate;
                      }
                      return null;
                    },
                    label: AppStrings.password,
                    obscureText: provider.isVisible ? false : true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        provider. isVisible ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.white,
                      ),
                      onPressed: () {
                       provider.checkVisible();
                      },
                    ),
                  ),
                  SizedBox(height: 105),
                  CustomButton(onTap: sumbit, title: AppStrings.signUp),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.alreadyAccount,
                        style: AppTextStyles.s15M.copyWith(
                          color: AppColors.white,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Nav.back();
                        },
                        child: Text(
                          AppStrings.login,
                          style: AppTextStyles.s17M.copyWith(
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
      ),
    );
  }
}
