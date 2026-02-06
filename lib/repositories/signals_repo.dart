import 'package:goldexia_fx/models/api_response.dart';
import 'package:goldexia_fx/models/trade_signal.dart';
import 'package:goldexia_fx/services/base_controller.dart';
import 'package:goldexia_fx/services/base_service.dart';
import 'package:goldexia_fx/services/local_db/user_session.dart';
import 'package:goldexia_fx/utils/res/app_urls.dart';
import 'package:goldexia_fx/utils/utils.dart';

class SignalsRepo extends BaseService with BaseController {
  Future<ApiResponse<List<TradeSignal>>> fetchSignals() async {
    try {
      final res = await get(AppUrls.signals);
      if (res == null) {
        return ApiResponse.error('Something went wrong');
      }

      final response = SignalsResponse.fromMap(res);
      return ApiResponse.success(response.signals ?? []);
    } catch (e) {
      Log.ex(e, name: 'SignalsRepo fetchSignals');
      return handleError(e);
    }
  }

  Future<ApiResponse<bool>> createSignal(TradeSignal signal) async {
    try {
      final res = await post(AppUrls.createSignal, signal.toMap());
      if (res == null) {
        return ApiResponse.error('Something went wrong');
      }
      return ApiResponse.success(true);
    } catch (e) {
      Log.ex(e, name: 'SignalsRepo createSignal');
      return handleError(e);
    }
  }

  Future<ApiResponse<bool>> updateSignal(TradeSignal signal) async {
    try {
      String apiPath = AppUrls.updateSignal.replaceFirst(
        '{signal_id}',
        signal.id.toString(),
      );

      if (apiPath.startsWith('/')) {
        apiPath = apiPath.substring(1);
      }

      final uriBase = Uri.parse(AppUrls.base);
      final host = uriBase.host;
      final basePath = uriBase.path;

      final fullPath = '$basePath/$apiPath'.replaceAll('//', '/');

      final token = UserSession.currentUser?.accessToken;
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final res = await put(
        fullPath,
        payLoadObj: signal.toMap(),
        baseUrl: host,
        header: headers,
      );

      if (res == null) {
        return ApiResponse.error('Something went wrong');
      }

      final success =
          res['success'] == true ||
          res['status'] == 'ok' ||
          res['message']?.toString().toLowerCase().contains('updated') == true;

      return ApiResponse.success(success);
    } catch (e) {
      Log.ex(e, name: 'SignalsRepo updateSignal');
      return handleError(e);
    }
  }

  // SignalsRepo (replace existing deleteSignal)
  Future<ApiResponse<bool>> deleteSignal(String id) async {
    try {
      // Replace placeholder with your actual delete endpoint template
      String apiPath = AppUrls.deleteSignal.replaceFirst(
        '{signal_id}',
        id.toString(),
      );

      if (apiPath.startsWith('/')) {
        apiPath = apiPath.substring(1);
      }

      final uriBase = Uri.parse(AppUrls.base);
      final host = uriBase.host;
      final basePath = uriBase.path;
      final fullPath = '$basePath/$apiPath'.replaceAll('//', '/');

      final res = await delete(fullPath, baseUrl: host);

      if (res == null) return ApiResponse.error('Something went wrong');

      final success =
          res['success'] == true ||
          res['status'] == 'ok' ||
          res['message']?.toString().toLowerCase().contains('deleted') == true;

      return ApiResponse.success(success);
    } catch (e) {
      Log.ex(e, name: 'SignalsRepo deleteSignalById');
      return handleError(e);
    }
  }
}
