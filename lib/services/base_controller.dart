import 'dart:convert';

import 'package:goldexia_fx/models/api_response.dart';
import 'package:goldexia_fx/utils/loader_dialogs.dart';

import '../utils/app_utils.dart';
import '../utils/res/app_urls.dart';
import '../utils/utils.dart';
import '../views/screens/auth/login_screen.dart';
import 'app_exceptions.dart';
import 'local_db/user_session.dart';

mixin BaseController {
  Future<ApiResponse<T>> handleError<T>(dynamic error) async {
    Loader.hide();
    if (error is BadRequestException) {
      final msg = _getMessage(error);
      AppUtils.showToast(msg);
      return ApiResponse<T>.error(msg);
    } else if (error is FetchDataException) {
      final msg = _getMessage(error);
      AppUtils.showToast(msg);
      return ApiResponse<T>.error(msg);
    } else if (error is ApiNotRespondingException) {
      AppUtils.showToast('No Internet');
      return ApiResponse<T>.error('No Internet');
    } else if (error is UnProcessableException) {
      final msg = _getMessage(error);
      AppUtils.showToast(msg);
      return ApiResponse<T>.error(msg);
    } else if (error is UnAutthorizedException) {
      final msg = _getMessage(error);
      AppUtils.showToast(msg);
      if (error.url.contains(AppUrls.login)) return ApiResponse<T>.error(error);

      UserSession.logoutUser();
      Nav.offAll(const LoginScreen());

      return ApiResponse<T>.error(error);
    } else {
      AppUtils.showToast('Something went wrong');
      return ApiResponse<T>.error('Something went wrong');
    }
  }

  String _getMessage(AppException error) {
    String? message;
    try {
      dynamic decodedRes = error.message.contains('{')
          ? jsonDecode(error.message)
          : error.message;
      message = decodedRes['message'];
    } catch (e) {
      message = error.message;
    }
    return message ?? 'Something went wrong';
  }
}
