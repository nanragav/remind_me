import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Remind Me';
  static const String appVersion = '1.0.0';

  // Animation durations
  static const Duration fastAnimation = Duration(milliseconds: 300);
  static const Duration normalAnimation = Duration(milliseconds: 600);
  static const Duration slowAnimation = Duration(milliseconds: 800);

  // Padding and margins
  static const double defaultPadding = 20.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 32.0;

  // Border radius
  static const double defaultRadius = 12.0;
  static const double largeRadius = 20.0;
  static const double smallRadius = 8.0;

  // Elevations
  static const double cardElevation = 8.0;
  static const double buttonElevation = 4.0;

  // Text sizes
  static const double titleFontSize = 24.0;
  static const double subtitleFontSize = 18.0;
  static const double bodyFontSize = 16.0;
  static const double captionFontSize = 14.0;
}

class AppImages {
  static const String splashLogo = 'assets/images/logo.png';
  static const String emptyState = 'assets/images/empty_state.png';
}

class AppSounds {
  static const String chime = 'assets/sounds/chime.mp3';
  static const String notification = 'assets/sounds/notification.wav';
}

extension TimeOfDayExtension on TimeOfDay {
  String get formatted {
    final hour =
        this.hour == 0 ? 12 : (this.hour > 12 ? this.hour - 12 : this.hour);
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  bool isAfter(TimeOfDay other) {
    return hour > other.hour || (hour == other.hour && minute > other.minute);
  }

  bool isBefore(TimeOfDay other) {
    return hour < other.hour || (hour == other.hour && minute < other.minute);
  }
}

extension DateTimeExtension on DateTime {
  String get formattedDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[month - 1]} $day, $year';
  }

  String get formattedTime {
    final hour =
        this.hour == 0 ? 12 : (this.hour > 12 ? this.hour - 12 : this.hour);
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}

class AppValidators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static bool isValidTime(int hour, int minute) {
    return hour >= 0 && hour < 24 && minute >= 0 && minute < 60;
  }
}

class HapticFeedbackHelper {
  static void lightImpact() {
    // Haptic feedback for light interactions
  }

  static void mediumImpact() {
    // Haptic feedback for medium interactions
  }

  static void heavyImpact() {
    // Haptic feedback for heavy interactions
  }
}
