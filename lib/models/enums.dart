enum DayOfWeek {
  monday('Monday', 'Mon'),
  tuesday('Tuesday', 'Tue'),
  wednesday('Wednesday', 'Wed'),
  thursday('Thursday', 'Thu'),
  friday('Friday', 'Fri'),
  saturday('Saturday', 'Sat'),
  sunday('Sunday', 'Sun');

  const DayOfWeek(this.fullName, this.shortName);

  final String fullName;
  final String shortName;

  static DayOfWeek fromDateTime(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return DayOfWeek.monday;
      case 2:
        return DayOfWeek.tuesday;
      case 3:
        return DayOfWeek.wednesday;
      case 4:
        return DayOfWeek.thursday;
      case 5:
        return DayOfWeek.friday;
      case 6:
        return DayOfWeek.saturday;
      case 7:
        return DayOfWeek.sunday;
      default:
        return DayOfWeek.monday;
    }
  }
}

enum Activity {
  wakeUp('Wake up', '🌅', 'Time to start your day!'),
  goToGym('Go to gym', '💪', 'Time for your workout!'),
  breakfast('Breakfast', '🍳', 'Time for breakfast!'),
  meetings('Meetings', '📋', 'You have meetings scheduled!'),
  lunch('Lunch', '🍽️', 'Time for lunch!'),
  quickNap('Quick nap', '😴', 'Time for a quick nap!'),
  goToLibrary('Go to library', '📚', 'Time to go to the library!'),
  dinner('Dinner', '🍽️', 'Time for dinner!'),
  goToSleep('Go to sleep', '🌙', 'Time to go to sleep!');

  const Activity(this.name, this.emoji, this.description);

  final String name;
  final String emoji;
  final String description;
}

enum ReminderStatus { active, completed, snoozed, cancelled }

enum SoundType {
  chime('Chime', 'assets/sounds/chime.mp3', '🔔'),
  bell('Bell', 'assets/sounds/bell.mp3', '🔔'),
  alarm('Alarm', 'assets/sounds/alarm.mp3', '⏰'),
  silent('Silent', '', '🔇');

  const SoundType(this.name, this.path, this.icon);

  final String name;
  final String path;
  final String icon;
}
