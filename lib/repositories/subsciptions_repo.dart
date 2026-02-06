import 'package:goldexia_fx/models/subscription.dart';

import '../models/api_response.dart';
import '../services/base_controller.dart';
import '../services/base_service.dart';
import '../utils/res/app_urls.dart';
import '../utils/utils.dart';

class SubsciptionsRepo extends BaseService with BaseController {
  Future<ApiResponse<List<SubscriptionData>?>> getSubscriptions() async {
    try {
      final res = await get(AppUrls.subscriptions);
      if (res == null) return ApiResponse.error('Something went wrong');
      return ApiResponse.success(Subscription.fromMap(res).subscriptions);
    } catch (e) {
      Log.ex(e, name: 'Subsciptions get res');
      return handleError(e);
    }
  }
}
