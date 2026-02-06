import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/auth_provider.dart';
import 'package:goldexia_fx/providers/login_screen_provider.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/utils.dart';
import 'package:goldexia_fx/views/screens/auth/email_screen.dart';
import 'package:goldexia_fx/views/screens/auth/signup_screen.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // User
  final String email = 'test@example.com';
  final String password = 'password';
  // Admin
  // final String email = 'admin@example.com';
  // final String password = 'password';

  late TextEditingController emailController;
  late TextEditingController passwordController;
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: kDebugMode ? email : null);
    passwordController = TextEditingController(
      text: kDebugMode ? password : null,
    );
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void sumbit() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    formKey.currentState!.save();

    context.read<AuthProvider>().login(
      emailController.text,
      passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginScreenProvider>(context);
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
                    AppStrings.login,
                    style: AppTextStyles.s24b.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 45),
                  CustomTextField(
                    controller: emailController,
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
                    controller: passwordController,
                    validator: (validate) {
                      if (validate == null ||
                          validate.isEmpty ||
                          validate.length < 6) {
                        return AppStrings.passwordValidate;
                      }
                      return null;
                    },

                    label: AppStrings.password,
                    obscureText: loginProvider.isVisible ? false : true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        loginProvider.isVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.white,
                      ),
                      onPressed: loginProvider.checkVisible,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          loginProvider.checkForgot();
                          Nav.to(EmailScreen(isForgot: loginProvider.isForgot));
                        },
                        child: Text(
                          AppStrings.forgot,
                          style: AppTextStyles.s14N.copyWith(
                            color: AppColors.white,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 120),
                  CustomButton(onTap: sumbit, title: AppStrings.login),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.dontHaveAccount,
                        style: AppTextStyles.s15M.copyWith(
                          color: AppColors.white,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Nav.to(SignupScreen());
                        },
                        child: Text(
                          AppStrings.signUp,
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
