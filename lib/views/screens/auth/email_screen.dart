import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/app_providers.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/utils.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key, required this.isForgot});
  final bool isForgot;

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailTec = TextEditingController(
    text: kDebugMode ? 'imrandev02@gmail.com' : null,
  );
  void sumbit() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    authProvider.sendPasswordOtp(emailTec.text, widget.isForgot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.logo, width: 100, height: 100),
                SizedBox(height: 50),
                Text(
                  AppStrings.emailaddress,
                  style: AppTextStyles.s18M.copyWith(
                    color: AppColors.white,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                Text(
                  AppStrings.emailDiscription,
                  style: AppTextStyles.s15M.copyWith(
                    color: Colors.grey[400],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25),
                CustomTextField(
                  controller: emailTec,
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
                SizedBox(height: 50),
                CustomButton(onTap: sumbit, title: AppStrings.conti),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
