import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // Singleton instance
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;

  // Private constructor
  LocalStorageService._();

  // Singleton accessor
  static LocalStorageService get instance {
    _instance ??= LocalStorageService._();
    return _instance!;
  }

  // Initialize SharedPreferences (call this in main.dart)
  static Future<LocalStorageService> init() async {
    _instance ??= LocalStorageService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Check if initialized
  bool get isInitialized => _preferences != null;

  // SharedPreferences Keys
  static const String _notificationEnabledKey = 'notification_enabled';
  static const String _notificationPermissionAskedKey =
      'notification_permission_asked';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  // ==================== Notification Permission Methods ====================

  /// Check if notification is enabled
  bool get isNotificationEnabled {
    return _preferences?.getBool(_notificationEnabledKey) ?? false;
  }

  /// Set notification enabled status
  Future<bool> setNotificationEnabled(bool value) async {
    return await _preferences?.setBool(_notificationEnabledKey, value) ?? false;
  }

  /// Set notification enabled status
  Future<void> clear() async {
    await _preferences?.clear();
  }

  /// Check if we've asked for notification permission
  bool get hasAskedNotificationPermission {
    return _preferences?.getBool(_notificationPermissionAskedKey) ?? false;
  }

  /// Set that we've asked for notification permission
  Future<bool> setNotificationPermissionAsked(bool value) async {
    return await _preferences?.setBool(
          _notificationPermissionAskedKey,
          value,
        ) ??
        false;
  }

  /// Clear notification permission data
  Future<void> clearNotificationData() async {
    await _preferences?.remove(_notificationEnabledKey);
    await _preferences?.remove(_notificationPermissionAskedKey);
  }

  // ==================== Onboarding Methods ====================

  /// Check if onboarding is completed
  bool get isOnboardingCompleted {
    return _preferences?.getBool(_onboardingCompletedKey) ?? false;
  }

  /// Set onboarding completion status
  Future<bool> setOnboardingCompleted(bool value) async {
    return await _preferences?.setBool(_onboardingCompletedKey, value) ?? false;
  }

  /// Clear onboarding data
  Future<void> clearOnboardingData() async {
    await _preferences?.remove(_onboardingCompletedKey);
  }

  /// Get string value
  String? getString(String key) {
    return _preferences?.getString(key);
  }

  /// Set string value
  Future<bool> setString(String key, String value) async {
    return await _preferences?.setString(key, value) ?? false;
  }

  /// Get int value
  int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  /// Set int value
  Future<bool> setInt(String key, int value) async {
    return await _preferences?.setInt(key, value) ?? false;
  }

  /// Get bool value
  bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  /// Set bool value
  Future<bool> setBool(String key, bool value) async {
    return await _preferences?.setBool(key, value) ?? false;
  }

  /// Get double value
  double? getDouble(String key) {
    return _preferences?.getDouble(key);
  }

  /// Set double value
  Future<bool> setDouble(String key, double value) async {
    return await _preferences?.setDouble(key, value) ?? false;
  }

  /// Get string list
  List<String>? getStringList(String key) {
    return _preferences?.getStringList(key);
  }

  /// Set string list
  Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences?.setStringList(key, value) ?? false;
  }

  /// Remove a key
  Future<bool> remove(String key) async {
    return await _preferences?.remove(key) ?? false;
  }
}
