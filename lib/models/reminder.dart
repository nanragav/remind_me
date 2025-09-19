import 'package:uuid/uuid.dart';
import 'enums.dart';

class Reminder {
  final String id;
  final DayOfWeek dayOfWeek;
  final TimeOfDay time;
  final Activity activity;
  final DateTime createdAt;
  final bool isRepeating;
  final SoundType soundType;
  ReminderStatus status;

  Reminder({
    String? id,
    required this.dayOfWeek,
    required this.time,
    required this.activity,
    DateTime? createdAt,
    this.isRepeating = true,
    this.soundType = SoundType.chime,
    this.status = ReminderStatus.active,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  DateTime get nextScheduledTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Calculate days until the target day
    int daysUntilTarget = (dayOfWeek.index + 1) - now.weekday;
    if (daysUntilTarget <= 0) {
      daysUntilTarget += 7; // Next week
    }

    final targetDate = today.add(Duration(days: daysUntilTarget));
    final scheduledTime = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      time.hour,
      time.minute,
    );

    // If the time is today but has already passed, schedule for next week
    if (scheduledTime.isBefore(now) && daysUntilTarget == 0) {
      return scheduledTime.add(const Duration(days: 7));
    }

    return scheduledTime;
  }

  String get formattedTime {
    final hour =
        time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayOfWeek': dayOfWeek.index,
      'hour': time.hour,
      'minute': time.minute,
      'activity': activity.index,
      'createdAt': createdAt.toIso8601String(),
      'isRepeating': isRepeating,
      'soundType': soundType.index,
      'status': status.index,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      dayOfWeek: DayOfWeek.values[json['dayOfWeek']],
      time: TimeOfDay(hour: json['hour'], minute: json['minute']),
      activity: Activity.values[json['activity']],
      createdAt: DateTime.parse(json['createdAt']),
      isRepeating: json['isRepeating'],
      soundType:
          json['soundType'] != null
              ? SoundType.values[json['soundType']]
              : SoundType.chime,
      status: ReminderStatus.values[json['status']],
    );
  }

  Reminder copyWith({
    DayOfWeek? dayOfWeek,
    TimeOfDay? time,
    Activity? activity,
    bool? isRepeating,
    SoundType? soundType,
    ReminderStatus? status,
  }) {
    return Reminder(
      id: id,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      time: time ?? this.time,
      activity: activity ?? this.activity,
      createdAt: createdAt,
      isRepeating: isRepeating ?? this.isRepeating,
      soundType: soundType ?? this.soundType,
      status: status ?? this.status,
    );
  }
}

class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  @override
  String toString() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeOfDay && other.hour == hour && other.minute == minute;
  }

  @override
  int get hashCode => hour.hashCode ^ minute.hashCode;
}
