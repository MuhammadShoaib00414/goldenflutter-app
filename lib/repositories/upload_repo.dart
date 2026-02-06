

import 'package:goldexia_fx/models/api_response.dart';
import 'package:goldexia_fx/models/proof_upload.dart';
import 'package:goldexia_fx/services/base_controller.dart';
import 'package:goldexia_fx/services/base_service.dart';
import 'package:goldexia_fx/utils/logs.dart';
import 'package:goldexia_fx/utils/res/app_urls.dart';

class ProofUploadsRepo extends BaseService with BaseController {
  Future<ApiResponse<List<ProofUploadModel>?>> getProofUploads() async {
    try {
      final res = await get(AppUrls.proofUploads);
      if (res == null) {
        return ApiResponse.error('Something went wrong');
      }

      return ApiResponse.success(
        ProofUploads.fromMap(res).proofUploads,
      );
    } catch (e) {
      Log.ex(e, name: 'ProofUploads get res');
      return handleError(e);
    }
  }
}
