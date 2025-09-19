import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reminder.dart' as models;
import '../providers/reminder_provider.dart';
import '../utils/responsive_helper.dart';

class TimePickerWidget extends StatelessWidget {
  const TimePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => _showTimePicker(context, provider),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getResponsiveSpacing(context, 16),
              vertical: ResponsiveHelper.getResponsiveSpacing(context, 16),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    provider.selectedTime != null
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                width: provider.selectedTime != null ? 2 : 1,
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color:
                      provider.selectedTime != null
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade400,
                  size: ResponsiveHelper.getResponsiveIconSize(context, 24),
                ),
                SizedBox(
                  width: ResponsiveHelper.getResponsiveSpacing(context, 12),
                ),
                Expanded(
                  child: Text(
                    provider.selectedTime != null
                        ? _formatTime(provider.selectedTime!)
                        : 'Select Time',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        16,
                      ),
                      color:
                          provider.selectedTime != null
                              ? Colors.black87
                              : Colors.grey.shade600,
                      fontWeight:
                          provider.selectedTime != null
                              ? FontWeight.w500
                              : FontWeight.normal,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color:
                      provider.selectedTime != null
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade400,
                  size: ResponsiveHelper.getResponsiveIconSize(context, 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTimePicker(BuildContext context, ReminderProvider provider) async {
    final currentTime = provider.selectedTime;
    final initialTime =
        currentTime != null
            ? TimeOfDay(hour: currentTime.hour, minute: currentTime.minute)
            : const TimeOfDay(hour: 9, minute: 0);

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              dialHandColor: Theme.of(context).primaryColor,
              dialBackgroundColor: Theme.of(
                context,
              ).primaryColor.withOpacity(0.1),
              hourMinuteColor: MaterialStateColor.resolveWith(
                (states) =>
                    states.contains(MaterialState.selected)
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade200,
              ),
              hourMinuteTextColor: MaterialStateColor.resolveWith(
                (states) =>
                    states.contains(MaterialState.selected)
                        ? Colors.white
                        : Colors.black87,
              ),
              dayPeriodColor: MaterialStateColor.resolveWith(
                (states) =>
                    states.contains(MaterialState.selected)
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade200,
              ),
              dayPeriodTextColor: MaterialStateColor.resolveWith(
                (states) =>
                    states.contains(MaterialState.selected)
                        ? Colors.white
                        : Colors.black87,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      provider.setSelectedTime(
        models.TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute),
      );
    }
  }

  String _formatTime(models.TimeOfDay time) {
    final hour =
        time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
