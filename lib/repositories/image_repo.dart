import 'package:goldexia_fx/models/file.dart';

import '../models/api_response.dart';
import '../services/base_controller.dart';
import '../services/base_service.dart';
import '../utils/res/app_urls.dart';
import '../utils/utils.dart';

class ImageRepo extends BaseService with BaseController {
  Future<ApiResponse<bool>> uploadProofs(
    List<String> paths,
    String accountId,
  ) async {
    try {
      final res = await uploadFile(
        AppUrls.uploadProof,
        [
          File(key: 'deposit_screenshot', path: paths[1]),
          File(key: 'optional_screenshot', path: paths[0]),
        ],
        fields: {'trading_account_id': accountId},
      );
      if (res == null) return ApiResponse.error('Something went wrong');
      return ApiResponse.success(res['success']);
    } catch (e) {
      Log.ex(e, name: 'ImageRepo uploadProofs');
      return handleError(e);
    }
  }




   Future<ApiResponse<bool>> uploadProofsOfSubscription(
    String path,
   
  ) async {
    try {
      final res = await uploadFile(
        AppUrls.uploadProof,
         fields: {'trading_account_id': 'deposit through crypto'},
        [
          File(key: 'deposit_screenshot', path: path),
        ],
       
      );
      if (res == null) return ApiResponse.error('Something went wrong');
      return ApiResponse.success(res['success']);
    } catch (e) {
      Log.ex(e, name: 'ImageRepo uploadProofsOfSubscription');
      return handleError(e);
    }
  }
}
