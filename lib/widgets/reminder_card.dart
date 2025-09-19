import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reminder.dart';
import '../models/enums.dart';
import '../providers/reminder_provider.dart';
import '../utils/responsive_helper.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;

  const ReminderCard({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.white.withOpacity(0.95)],
          ),
        ),
        child: Padding(
          padding: ResponsiveHelper.getResponsivePadding(context),
          child:
              ResponsiveHelper.isSmallScreen(context)
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildActivityIcon(),
            SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 12)),
            Expanded(child: _buildReminderInfo()),
          ],
        ),
        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 12)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildStatusChip(), _buildActionButtons(context)],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        _buildActivityIcon(),
        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 16)),
        Expanded(child: _buildReminderInfo()),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildActivityIcon() {
    return Builder(
      builder:
          (context) => Container(
            width: ResponsiveHelper.isSmallScreen(context) ? 50 : 60,
            height: ResponsiveHelper.isSmallScreen(context) ? 50 : 60,
            decoration: BoxDecoration(
              color: _getActivityColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getActivityColor().withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                reminder.activity.emoji,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 28),
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildReminderInfo() {
    return Builder(
      builder:
          (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reminder.activity.name,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 4),
              ),
              Text(
                reminder.activity.description,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 8),
              ),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: ResponsiveHelper.getResponsiveIconSize(context, 16),
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getResponsiveSpacing(context, 4),
                  ),
                  Text(
                    reminder.formattedTime,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        14,
                      ),
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getResponsiveSpacing(context, 16),
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: ResponsiveHelper.getResponsiveIconSize(context, 16),
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getResponsiveSpacing(context, 4),
                  ),
                  Text(
                    reminder.dayOfWeek.shortName,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        14,
                      ),
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              if (!ResponsiveHelper.isSmallScreen(context)) ...[
                SizedBox(
                  height: ResponsiveHelper.getResponsiveSpacing(context, 8),
                ),
                _buildStatusChip(),
              ],
            ],
          ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String text;

    switch (reminder.status) {
      case ReminderStatus.active:
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green.shade700;
        icon = Icons.check_circle;
        text = 'Active';
        break;
      case ReminderStatus.completed:
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue.shade700;
        icon = Icons.done_all;
        text = 'Completed';
        break;
      case ReminderStatus.snoozed:
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange.shade700;
        icon = Icons.snooze;
        text = 'Snoozed';
        break;
      case ReminderStatus.cancelled:
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red.shade700;
        icon = Icons.cancel;
        text = 'Cancelled';
        break;
    }

    return Builder(
      builder:
          (context) => Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getResponsiveSpacing(context, 8),
              vertical: ResponsiveHelper.getResponsiveSpacing(context, 4),
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: ResponsiveHelper.getResponsiveIconSize(context, 14),
                  color: textColor,
                ),
                SizedBox(
                  width: ResponsiveHelper.getResponsiveSpacing(context, 4),
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      12,
                    ),
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ResponsiveHelper.isSmallScreen(context)
        ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<ReminderProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  onPressed: () => provider.toggleReminderStatus(reminder.id),
                  icon: Icon(
                    reminder.status == ReminderStatus.active
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color:
                        reminder.status == ReminderStatus.active
                            ? Colors.orange
                            : Colors.green,
                    size: ResponsiveHelper.getResponsiveIconSize(context, 24),
                  ),
                  tooltip:
                      reminder.status == ReminderStatus.active
                          ? 'Pause Reminder'
                          : 'Activate Reminder',
                );
              },
            ),
            Consumer<ReminderProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  onPressed: () => _showDeleteDialog(context, provider),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: ResponsiveHelper.getResponsiveIconSize(context, 20),
                  ),
                  tooltip: 'Delete Reminder',
                );
              },
            ),
          ],
        )
        : Column(
          children: [
            Consumer<ReminderProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  onPressed: () => provider.toggleReminderStatus(reminder.id),
                  icon: Icon(
                    reminder.status == ReminderStatus.active
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color:
                        reminder.status == ReminderStatus.active
                            ? Colors.orange
                            : Colors.green,
                    size: ResponsiveHelper.getResponsiveIconSize(context, 28),
                  ),
                  tooltip:
                      reminder.status == ReminderStatus.active
                          ? 'Pause Reminder'
                          : 'Activate Reminder',
                );
              },
            ),
            Consumer<ReminderProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  onPressed: () => _showDeleteDialog(context, provider),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: ResponsiveHelper.getResponsiveIconSize(context, 24),
                  ),
                  tooltip: 'Delete Reminder',
                );
              },
            ),
          ],
        );
  }

  Color _getActivityColor() {
    switch (reminder.activity) {
      case Activity.wakeUp:
        return Colors.orange;
      case Activity.goToGym:
        return Colors.red;
      case Activity.breakfast:
        return Colors.amber;
      case Activity.meetings:
        return Colors.blue;
      case Activity.lunch:
        return Colors.green;
      case Activity.quickNap:
        return Colors.purple;
      case Activity.goToLibrary:
        return Colors.teal;
      case Activity.dinner:
        return Colors.deepOrange;
      case Activity.goToSleep:
        return Colors.indigo;
    }
  }

  void _showDeleteDialog(BuildContext context, ReminderProvider provider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete Reminder'),
              ],
            ),
            content: Text(
              'Are you sure you want to delete the reminder for "${reminder.activity.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  provider.deleteReminder(reminder.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reminder deleted successfully'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
