import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:goldexia_fx/repositories/image_repo.dart';
import 'package:goldexia_fx/utils/app_utils.dart';
import 'package:goldexia_fx/utils/loader_dialogs.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageProvider extends ChangeNotifier {
  File? _imageTwo;
  File? _image;
  File? _picture;

  File? get picture => _picture;

  File? get imageOne => _image;
  File? get imageTwo => _imageTwo;
  final ImagePicker _picker = ImagePicker();
  final ImageRepo _repo = ImageRepo();
  Future<void> pickImage(int containerNumber) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: double.infinity,
    );

    if (pickedFile == null) return;

    if (containerNumber == 0) {
      _image = File(pickedFile.path);
      notifyListeners();
    }
    if (containerNumber == 1) {
      _imageTwo = File(pickedFile.path);
      notifyListeners();
    }
    notifyListeners();
  }

  Future<bool> uploadsProofs(String accountId) async {
    if (imageOne == null || imageTwo == null) {
      AppUtils.showToast('Both screenshots are required');
      return false; 
    }
    try {
      Loader.show();
      await _repo.uploadProofs([imageOne!.path, imageTwo!.path], accountId);
      Loader.hide();
      AppUtils.showToast('Proof uploaded successfully');
      return true;
    } catch (e) {
      Loader.hide();
      AppUtils.showToast('Proof uploaded failed!.Try again');
      return false;
    }
  }

  void removeImage() {
    _image = null;
    _imageTwo = null;
    _picture=null;
    notifyListeners();
  }

  Future<void> imagePicker() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: double.infinity,
    );

    if (pickedFile == null) return;

    _picture = File(pickedFile.path);
   debugPrint('Selected picture path: ${_picture!.path}');
    notifyListeners();
  }




  
  Future<bool> uploadsProofsOfSubscription() async {
    if (picture == null ) {
      AppUtils.showToast(' screenshot is required');

      return false;
    }
    try {
      debugPrint('Uploading picture: ${picture!.path}');
      Loader.show();
      await _repo.uploadProofsOfSubscription(picture!.path,);
      Loader.hide();
      AppUtils.showToast('Proof uploaded successfully');
      return true;
    } catch (e) {
      Loader.hide();
       debugPrint('Upload error: $e');
      AppUtils.showToast('Proof uploaded failed!.Try again');
      return false;
    }
  }
}
