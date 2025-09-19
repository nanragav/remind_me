import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import '../models/enums.dart';
import '../services/audio_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final androidImplementation =
        _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      // Request notification permission
      final notificationPermission =
          await androidImplementation.requestNotificationsPermission();
      print('Notification permission granted: $notificationPermission');

      // Request exact alarm permission
      final exactAlarmPermission =
          await androidImplementation.requestExactAlarmsPermission();
      print('Exact alarm permission granted: $exactAlarmPermission');
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - play sound when notification is tapped
    print('Notification tapped: ${response.payload}');

    // Extract sound type from payload if available
    SoundType soundType = SoundType.chime;
    if (response.payload != null && response.payload!.contains('sound:')) {
      final soundTypeStr = response.payload!.split('sound:')[1].split('|')[0];
      soundType = SoundType.values.firstWhere(
        (e) => e.toString().split('.').last == soundTypeStr,
        orElse: () => SoundType.chime,
      );
    }

    // Play sound when notification is received
    AudioService().playNotificationSound(soundType: soundType);
  }

  Future<void> scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required DayOfWeek dayOfWeek,
    SoundType soundType = SoundType.chime,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'reminder_channel',
          'Reminder Notifications',
          channelDescription: 'Daily activity reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: 'reminder_$id|sound:${soundType.toString().split('.').last}',
      );
      print('Notification scheduled successfully for $title at $scheduledDate');
    } catch (e) {
      print('Error scheduling notification: $e');
      // Try fallback with basic scheduling
      try {
        await _notifications.show(
          id,
          title,
          body,
          details,
          payload: 'reminder_$id|sound:${soundType.toString().split('.').last}',
        );
        print('Fallback notification shown immediately');
      } catch (fallbackError) {
        print('Fallback notification also failed: $fallbackError');
      }
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<bool> requestPermissions() async {
    try {
      final androidImplementation =
          _notifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImplementation != null) {
        // Request notification permission
        final notificationPermission =
            await androidImplementation.requestNotificationsPermission();
        print('Notification permission granted: $notificationPermission');

        // Request exact alarm permission
        final exactAlarmPermission =
            await androidImplementation.requestExactAlarmsPermission();
        print('Exact alarm permission granted: $exactAlarmPermission');

        return (notificationPermission ?? false) &&
            (exactAlarmPermission ?? false);
      }
      return true;
    } catch (e) {
      print('Error requesting permissions: $e');
      return false;
    }
  }
}
