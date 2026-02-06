import 'package:flutter/foundation.dart';
import 'package:goldexia_fx/models/user.dart';
import 'package:goldexia_fx/repositories/auth_repo.dart';
import 'package:goldexia_fx/services/local_db/user_session.dart';
import 'package:goldexia_fx/utils/app_utils.dart';
import 'package:goldexia_fx/utils/loader_dialogs.dart';
import 'package:goldexia_fx/utils/utils.dart';
import 'package:goldexia_fx/views/screens/admin/signals_screen.dart';
import 'package:goldexia_fx/views/screens/auth/login_screen.dart';
import 'package:goldexia_fx/views/screens/auth/new_password.dart';
import 'package:goldexia_fx/views/screens/auth/verify_screen.dart';

import 'app_providers.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo _repo = AuthRepo();
  String? logo;
  UserData user = UserData();
  //
  Future<void> login(String email, String password) async {
    user = UserData(email: email, password: password);
    Loader.show();
    final res = await _repo.login(user);
    Loader.hide();
    if (res.message.toString().contains('Email not verified')) {
      Nav.to(VerifyScreen());
    }
    if (!res.isSuccess || res.data == null) return;
    onSuccessLogin(res.data!);
  }

  Future<void> register(String name, String email, String password) async {
    Loader.show();
    user = UserData(email: email, password: password, fullName: name);
    final res = await _repo.register(user);
    if (!res.isSuccess) return;
    Loader.hide();
    if (res.data == true) Nav.to(VerifyScreen());
    Log.d(res, name: 'register authProvider');
  }

  Future<void> verifyOTPForEmail(String otp, isForgot) async {
    if (isForgot) {
      verifyPasswordOtp(otp);
    } else {
      Loader.show();
      final res = await _repo.verifyEmailOTP(user.copyWith(otp: otp));

      if (!res.isSuccess) return;
      Loader.hide();
      if (res.isSuccess) onSuccessLogin(res.data!);
      Log.d(res, name: 'register authProvider');
    }
  }

  Future<void> sendEmailOTP() async {
    Loader.show();
    final res = await _repo.sendEmailOtp(user.email ?? '');
    if (!res.isSuccess) return;
    Loader.hide();
    AppUtils.showToast('OTP sent successfully. Check your email');
  }

  Future<void> onSuccessLogin(User data) async {
    await UserSession.saveUser(data);
    Nav.offAll(
      data.user?.role == 'user' ? await initializeScreen() : SignalsScreen(),
    );
  }

  String resetToken = '';
  Future<void> verifyPasswordOtp(String otp) async {
    Loader.show();
    final res = await _repo.verifyPasswordOTP(user.copyWith(otp: otp));
    if (!res.isSuccess) return;

    Loader.hide();
    if (res.isSuccess) Nav.to(NewPasswordScreen());
    resetToken = res.data!.resetToken ?? '';
    Log.d(res, name: 'register authProvider');
  }

  Future<void> sendPasswordOtp(String email, bool isForgot) async {
    Loader.show();
    user = user.copyWith(email: email);
    final res = await _repo.sendPasswordOTP(email);
    if (!res.isSuccess) return;
    Loader.hide();
    Nav.to(VerifyScreen(isForgot: isForgot));
    AppUtils.showToast('OTP sent successfully. Check your email');
  }

  Future<void> updatePassword(String password) async {
    Loader.show();
    user = user.copyWith(password: password);
    final res = await _repo.updatePassword(
      User(
        resetToken: resetToken,
        user: user.copyWith(password: password),
      ),
    );
    if (!res.isSuccess) return;
    Loader.hide();
    Nav.to(LoginScreen());
  }

  /// Register FCM token with backend
  Future<bool> registerFcmToken(String fcmToken) async {
    try {
      await UserSession.getUser();
      final res = await _repo.registerFcmToken(fcmToken);
      if (res.isSuccess) {
        Log.success('FCM token registered successfully', name: 'AuthProvider');
        return true;
      } else {
        Log.d('Failed to register FCM token: ${res.message}', name: 'AuthProvider');
        return false;
      }
    } catch (e) {
      Log.ex(e, name: 'AuthProvider registerFcmToken');
      return false;
    }
  }
}
