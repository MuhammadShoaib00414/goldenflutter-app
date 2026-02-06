import 'package:goldexia_fx/models/api_response.dart';

import '../models/user.dart';
import '../services/base_controller.dart';
import '../services/base_service.dart';
import '../utils/res/app_urls.dart';
import '../utils/utils.dart';

class AuthRepo extends BaseService with BaseController {
  Future<ApiResponse<bool>> register(UserData user) async {
    try {
      final res = await post(AppUrls.register, user.toMapToRegister());
      if (res == null) return ApiResponse.error('Something went wrong');
      return ApiResponse.success(res['success']);
    } catch (e) {
      Log.ex(e, name: 'AuthRepo Register');
      return handleError(e);
    }
  }

  Future<ApiResponse<bool>> sendEmailOtp(String email) async {
    try {
      final res = await post(AppUrls.sendEmailOtp, {'email': email});
      return ApiResponse.success(res['success']);
    } catch (e) {
      Log.ex(e, name: 'AuthRepo Login');
      return handleError(e);
    }
  }

  Future<ApiResponse<User>> verifyEmailOTP(UserData user) async {
    try {
      final res = await post(
        AppUrls.verifyEmailOtp,
        user.toMapToVerifyPasswordOTP(),
      );
      return ApiResponse.success(User.fromMap(res['data']));
    } catch (e) {
      Log.ex(e, name: 'AuthRepo Login');
      return handleError(e);
    }
  }

  Future<ApiResponse<User>> login(UserData user) async {
    try {
      final res = await post(AppUrls.login, user.toMapToLogin());
      if (res == null) return ApiResponse.error('Something went wrong');
      return ApiResponse.success(User.fromMap(res['data']));
    } catch (e) {
      Log.ex(e, name: 'AuthRepo Login');
      return handleError(e);
    }
  }

  Future<ApiResponse<bool>> sendPasswordOTP(String email) async {
    try {
      final res = await post(AppUrls.sendPasswordOtp, {'email': email});
      return ApiResponse.success(res['success']);
    } catch (e) {
      Log.ex(e, name: 'AuthRepo Login');
      return handleError(e);
    }
  }

  Future<ApiResponse<User>> verifyPasswordOTP(UserData user) async {
    try {
      final res = await post(
        AppUrls.verifyPasswordOtp,
        user.toMapToVerifyPasswordOTP(),
      );
      return ApiResponse.success(User.fromMap(res['data']));
    } catch (e) {
      Log.ex(e, name: 'AuthRepo Login');
      return handleError(e);
    }
  }

  Future<ApiResponse<bool>> updatePassword(User user) async {
    try {
      final res = await post(
        AppUrls.resetPassword,
        user.toMapToResetForgottenPassword(),
      );
      return ApiResponse.success(res['success']);
    } catch (e) {
      Log.ex(e, name: 'AuthRepo Login');
      return handleError(e);
    }
  }

  Future<ApiResponse<bool>> registerFcmToken(String fcmToken) async {
    try {
      final res = await post(AppUrls.registerFcmToken, {'fcm_token': fcmToken});
      return ApiResponse.success(res['success'] ?? true);
    } catch (e) {
      Log.ex(e, name: 'AuthRepo registerFcmToken');
      return handleError(e);
    }
  }
}
