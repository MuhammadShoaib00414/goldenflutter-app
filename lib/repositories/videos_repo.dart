import 'package:goldexia_fx/models/api_response.dart';
import 'package:goldexia_fx/models/videos_model.dart';
import 'package:goldexia_fx/services/base_controller.dart';
import 'package:goldexia_fx/services/base_service.dart';
import 'package:goldexia_fx/utils/logs.dart';
import 'package:goldexia_fx/utils/res/app_urls.dart';

class VideosRepo extends BaseService with BaseController {
  Future<ApiResponse<List<VideosModel>?>> getVideos() async {
    try {
      final res = await get(AppUrls.videos,);
      if (res == null) return ApiResponse.error('Something went wrong');
      return ApiResponse.success(Videos.fromMap(res).videos);
    } catch (e) {
      Log.ex(e, name: 'Videos get res');
      return handleError(e);
    }
  }
}
