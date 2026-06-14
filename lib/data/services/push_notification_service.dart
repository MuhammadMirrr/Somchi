import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'price_alerts',
    'Price Alerts',
    description: 'Notifications for currency price alerts',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  @pragma('vm:entry-point')
  static Future<void> backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(initializationSettings);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
  }

  Future<bool> requestPermissionIfNeeded() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    }

    final androidImplementation = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final isGranted = await androidImplementation?.areNotificationsEnabled();
    if (isGranted == true) return true;

    final result = await androidImplementation?.requestNotificationsPermission();
    return result ?? false;
  }

  Future<String?> getToken() => FirebaseMessaging.instance.getToken();

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'price_alerts',
          'Price Alerts',
          channelDescription: 'Notifications for currency price alerts',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}
