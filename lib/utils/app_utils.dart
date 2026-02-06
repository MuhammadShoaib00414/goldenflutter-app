import 'package:fluttertoast/fluttertoast.dart';

class AppUtils {
  AppUtils._();
  static Future<bool?> showToast(String msg) => Fluttertoast.showToast(
    msg: msg,
    // toastLength: Toast.LENGTH_LONG,
    // backgroundColor: AppColors.red,
  );
}
