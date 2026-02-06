import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:goldexia_fx/providers/app_providers.dart';

import '../../utils/logs.dart';
import '../local_db/local_storage.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    if (e is FirebaseException && e.code == 'duplicate-app') {
      Firebase.app();
    } else {
      rethrow;
    }
  }
  Log.d('Handling a background message: ${message.messageId}');
  Log.d('Background message data: ${message.data}');

  // Handle background message Log.dic here
  // await NotificationService._handleBackgroundMessage(message);
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;
  static String? _deviceToken;

  /// Initialize the notification service
  static Future<void> initialize([bool? enabled]) async {
    enabled ??= LocalStorageService.instance.isNotificationEnabled;
    if (!enabled) {
      Log.d(
        '⚠️ Notifications not enabled, skipping initialization ${LocalStorageService.instance.isNotificationEnabled}',
      );
      return;
    }

    if (_isInitialized) {
      Log.d('⚠️ NotificationService already initialized');
      return;
    }

    try {
      Log.d('------===============-------initializing notifications');

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get and print device token (non-blocking)
      // Even if this fails, the app should continue working
      _getDeviceToken().catchError((error) {
        Log.d('⚠️ Failed to get device token, but continuing initialization');
        return null;
      });

      // Setup message handlers (foreground only)
      _setupMessageHandlers();

      _isInitialized = true;
      Log.d('✅ NotificationService initialized successfully');
    } catch (e) {
      Log.d('❌ Error initializing NotificationService: $e');
      // Mark as initialized anyway to prevent repeated attempts
      _isInitialized = true;
    }
  }

  /// Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
  }

  /// Create notification channel for Android
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'kortalausnir_channel',
      'Kortalausnir Notifications',
      description: 'Notifications for Kortalausnir',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(channel);
    }
  }

  /// Get and store device token
  static Future<void> _getDeviceToken() async {
    try {
      // Check if running on a platform that supports FCM
      if (kIsWeb) {
        Log.d('⚠️ FCM tokens are not supported on Web platform');
        return;
      }

      _deviceToken = await _firebaseMessaging.getToken();

      if (_deviceToken != null) {
        // Save token to local storage
        Log.success('🔑 FCM Device Token: $_deviceToken');
        await authProvider.registerFcmToken(_deviceToken!);
        if (kDebugMode) {
          Log.d('=== FCM DEVICE TOKEN FOR TESTING ===');
          Log.d(_deviceToken);
          Log.d('====================================');
        }
      } else {
        Log.d(
          '⚠️ FCM token is null - Google Play Services might not be available',
        );
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen(
        (String token) {
          _deviceToken = token;
          Log.d('🔄 FCM Token refreshed: $token');
          authProvider.registerFcmToken(_deviceToken!);
          if (kDebugMode) {
            Log.d('=== NEW FCM TOKEN ===');
            Log.d(token);
            Log.d('====================');
          }
        },
        onError: (error) {
          Log.d('❌ Error on token refresh: $error');
        },
      );
    } catch (e) {
      Log.d('❌ Error getting device token: $e');

      // Provide helpful error messages
      //
    }
  }

  /// Setup message handlers for different app states
  static void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Log.d('📱 Foreground message received: ${message.messageId}');
      _handleForegroundMessage(message);
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Log.d(
        '🔄 App opened from background via notification: ${message.messageId}',
      );
      _handleNotificationTap(message);
    });

    // Handle notification tap when app is terminated
    _handleInitialMessage();
  }

  /// Handle messages when app is in foreground
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    Log.d('Handling foreground message: ${message.notification?.title}');

    // Show local notification even when app is in foreground
    await _showLocalNotification(message);
  }

  /// Handle messages when app is in background or terminated
  /// This is called from the top-level background handler in main.dart
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    Log.d('Handling background message: ${message.notification?.title}');
    Log.d('Background message data: ${message.data}');

    // You can perform background tasks here like:
    // - Update local database
    // - Send analytics
    // - Process data
    // Note: UI operations are not allowed in background
  }

  /// Handle notification tap
  static Future<void> _handleNotificationTap(RemoteMessage message) async {
    Log.d('Notification tapped: ${message.data}');

    // Navigate to specific screen based on notification data
    if (message.data.containsKey('screen')) {
      final screen = message.data['screen'];
      Log.d('Navigating to screen: $screen');
      // Add navigation logic here
      // You can use a callback or GlobalKey<NavigatorState> to navigate
    }
  }

  /// Handle initial message when app is opened from terminated state
  static Future<void> _handleInitialMessage() async {
    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();

    if (initialMessage != null) {
      Log.d(
        '🚀 App opened from terminated state via notification: ${initialMessage.messageId}',
      );
      _handleNotificationTap(initialMessage);
    }
  }

  /// Show local notification
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'kortalausnir_channel',
          'Kortalausnir Notifications',
          channelDescription: 'Notifications for Kortalausnir',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Kortalausnir',
      message.notification?.body ?? 'New notification',
      platformDetails,
      payload: message.data.toString(),
    );
  }

  /// Handle local notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    Log.d('Local notification tapped: ${response.payload}');
    // Handle local notification tap
  }

  /// Get current device token
  static String? get deviceToken => _deviceToken;

  /// Check if service is initialized
  static bool get isInitialized => _isInitialized;

  /// Show a custom local notification
  static Future<void> showCustomNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'gps_channel',
          'gps Notifications',
          channelDescription: 'Notifications for gps',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  /// Get notification settings
  static Future<NotificationSettings> getNotificationSettings() async {
    return await _firebaseMessaging.getNotificationSettings();
  }
}
