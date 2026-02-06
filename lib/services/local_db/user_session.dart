
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goldexia_fx/utils/utils.dart';

import '../../models/user.dart';

class UserSession {
  UserSession._();

  //
  static User? currentUser;
  static const String _userkey = 'user';
  //
  // static Future<User?> getUser() async {
  //   const storage = FlutterSecureStorage();
  //   String? value = await storage.read(key: _userkey);
  //   Log.success(value, name: 'Current User');
  //   currentUser =  value == null ? null : User.fromJson(value);
  //   return currentUser;
  // }

  static Future<User?> getUser() async {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: _userkey);
    Log.success(value, name: 'Current User');

    if (value == null) {
      currentUser = null;
      return null;
    }

    try {
      // ✅ Pass the raw string directly (your model handles decoding)
      currentUser = User.fromJson(value);
    } catch (e) {
      Log.ex(e, name: 'UserSession.getUser');
      currentUser = null;
    }

    return currentUser;
  }

  static Future<void> saveUser(User user) async {
    const storage = FlutterSecureStorage();
    currentUser = user;
    Log.success(user, name: 'Save User');
     await storage.write(key: _userkey, value: user.toJson());
  }

  static Future<void> logoutUser() async {
    const storage = FlutterSecureStorage();
    currentUser = null;
    await storage.delete(key: _userkey);
  }

  static bool get isAdmin => currentUser?.user?.role == 'admin';
  static bool get isUser => currentUser?.user?.role == 'user';

}
