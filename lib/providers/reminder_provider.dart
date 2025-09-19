import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder.dart';
import '../models/enums.dart';
import '../services/notification_service.dart';
import '../services/audio_service.dart';

class ReminderProvider extends ChangeNotifier {
  List<Reminder> _reminders = [];
  DayOfWeek? _selectedDay;
  TimeOfDay? _selectedTime;
  Activity? _selectedActivity;
  SoundType? _selectedSound;
  bool _isLoading = false;

  final NotificationService _notificationService = NotificationService();
  final AudioService _audioService = AudioService();

  List<Reminder> get reminders => _reminders;
  DayOfWeek? get selectedDay => _selectedDay;
  TimeOfDay? get selectedTime => _selectedTime;
  Activity? get selectedActivity => _selectedActivity;
  SoundType? get selectedSound => _selectedSound;
  bool get isLoading => _isLoading;

  List<Reminder> get activeReminders =>
      _reminders.where((r) => r.status == ReminderStatus.active).toList();

  List<Reminder> get todayReminders {
    final today = DayOfWeek.fromDateTime(DateTime.now());
    return activeReminders.where((r) => r.dayOfWeek == today).toList()
      ..sort((a, b) => a.time.hour.compareTo(b.time.hour));
  }

  ReminderProvider() {
    _initializeServices();
    loadReminders();
  }

  Future<void> _initializeServices() async {
    await _notificationService.initialize();
    await _audioService.initialize();
  }

  void setSelectedDay(DayOfWeek? day) {
    _selectedDay = day;
    notifyListeners();
  }

  void setSelectedTime(TimeOfDay? time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setSelectedActivity(Activity? activity) {
    _selectedActivity = activity;
    notifyListeners();
  }

  void setSelectedSound(SoundType? sound) {
    _selectedSound = sound;
    notifyListeners();
  }

  Future<void> addReminder() async {
    if (_selectedDay == null ||
        _selectedTime == null ||
        _selectedActivity == null) {
      throw Exception('Please select all required fields');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final reminder = Reminder(
        dayOfWeek: _selectedDay!,
        time: _selectedTime!,
        activity: _selectedActivity!,
        soundType: _selectedSound ?? SoundType.chime,
      );

      _reminders.add(reminder);
      await _scheduleNotification(reminder);
      await _saveReminders();

      // Clear selections
      _selectedDay = null;
      _selectedTime = null;
      _selectedActivity = null;
      _selectedSound = null;
      _selectedActivity = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateReminder(Reminder updatedReminder) async {
    final index = _reminders.indexWhere((r) => r.id == updatedReminder.id);
    if (index != -1) {
      _reminders[index] = updatedReminder;
      await _scheduleNotification(updatedReminder);
      await _saveReminders();
      notifyListeners();
    }
  }

  Future<void> deleteReminder(String id) async {
    _reminders.removeWhere((r) => r.id == id);
    await _notificationService.cancelNotification(id.hashCode);
    await _saveReminders();
    notifyListeners();
  }

  Future<void> toggleReminderStatus(String id) async {
    final reminder = _reminders.firstWhere((r) => r.id == id);
    final newStatus =
        reminder.status == ReminderStatus.active
            ? ReminderStatus.cancelled
            : ReminderStatus.active;

    await updateReminder(reminder.copyWith(status: newStatus));
  }

  Future<void> _scheduleNotification(Reminder reminder) async {
    if (reminder.status == ReminderStatus.active) {
      await _notificationService.scheduleWeeklyNotification(
        id: reminder.id.hashCode,
        title: '${reminder.activity.emoji} ${reminder.activity.name}',
        body: reminder.activity.description,
        scheduledTime: reminder.nextScheduledTime,
        dayOfWeek: reminder.dayOfWeek,
        soundType: reminder.soundType,
      );
    }
  }

  Future<void> playReminderSound({
    SoundType soundType = SoundType.chime,
  }) async {
    await _audioService.playNotificationSound(soundType: soundType);
  }

  Future<void> previewSound(SoundType soundType) async {
    await _audioService.previewSound(soundType);
  }

  String getSoundDisplayName(SoundType soundType) {
    return _audioService.getSoundDisplayName(soundType);
  }

  Future<bool> requestNotificationPermissions() async {
    return await _notificationService.requestPermissions();
  }

  Future<void> loadReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final remindersJson = prefs.getStringList('reminders') ?? [];

      _reminders =
          remindersJson
              .map((json) => Reminder.fromJson(jsonDecode(json)))
              .toList();

      // Re-schedule notifications for active reminders
      for (final reminder in activeReminders) {
        await _scheduleNotification(reminder);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading reminders: $e');
    }
  }

  Future<void> _saveReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final remindersJson =
          _reminders.map((reminder) => jsonEncode(reminder.toJson())).toList();

      await prefs.setStringList('reminders', remindersJson);
    } catch (e) {
      debugPrint('Error saving reminders: $e');
    }
  }

  void clearSelections() {
    _selectedDay = null;
    _selectedTime = null;
    _selectedActivity = null;
    _selectedSound = null;
    notifyListeners();
  }

  void clearFilters() {
    // This method can be used to clear any active filters in the UI
    // Currently reminders are filtered by day/activity in the UI components
    notifyListeners();
  }

  bool get canAddReminder =>
      _selectedDay != null &&
      _selectedTime != null &&
      _selectedActivity != null;
}
