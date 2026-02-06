import 'package:flutter/foundation.dart';
import 'package:goldexia_fx/models/api_response.dart';
import 'package:goldexia_fx/models/proof_upload.dart';
import 'package:goldexia_fx/repositories/upload_repo.dart';

class ProofUploadsProvider extends ChangeNotifier {
  final ProofUploadsRepo _repo = ProofUploadsRepo();

  ApiResponse<List<ProofUploadModel>?> proofUploads = ApiResponse.loading();

  ProofUploadModel? proof;
  bool ignoreApi = false;

  Future<void> fetchProofs() async {
    if (ignoreApi) return;
    final res = await _repo.getProofUploads();
    _setProofs(res);
  }

  void _setProofs(ApiResponse<List<ProofUploadModel>?> res) {
    proofUploads = res;

    // ✅ IMPORTANT: handle EMPTY proof_uploads
    if (res.data == null || res.data!.isEmpty) {
      proof = null; // means NEW USER
    } else {
      proof = res.data!.first;
    }

    notifyListeners();
  }

  
  bool get hasProof => proof != null;


  bool get isNewUser => proof == null;


  String? get status => proof?.status;

  bool get isPending => status == 'Pending';
  bool get isApproved => status == 'Approved';
  bool get isRejected => status == 'Rejected';


  String? get depositUrl => proof?.depositScreenshotUrl;
  String? get optionalUrl => proof?.optionalScreenshotUrl;
  String? get rejectionReason => proof?.rejectionReason;

  void resetProof() {
    ignoreApi = true;
    proofUploads = ApiResponse.success([]);
    proof = null;
    notifyListeners();
  }

  void unlockAndRefresh() {
    ignoreApi = false;
    fetchProofs();
  }
}
