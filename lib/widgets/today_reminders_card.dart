import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reminder_provider.dart';
import '../models/enums.dart';
import '../widgets/reminder_card.dart';
import '../utils/responsive_helper.dart';

class TodayRemindersCard extends StatefulWidget {
  final VoidCallback? onNavigateToAddReminder;

  const TodayRemindersCard({super.key, this.onNavigateToAddReminder});

  @override
  State<TodayRemindersCard> createState() => _TodayRemindersCardState();
}

class _TodayRemindersCardState extends State<TodayRemindersCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Consumer<ReminderProvider>(
        builder: (context, provider, child) {
          final todayReminders = provider.todayReminders;

          if (todayReminders.isEmpty) {
            return _buildEmptyTodayState();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTodayHeader(todayReminders.length),
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 20),
              ),
              Expanded(child: _buildTodayRemindersList(todayReminders)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTodayHeader(int reminderCount) {
    final today = DateTime.now();
    final dayName = DayOfWeek.fromDateTime(today).fullName;

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: EdgeInsets.all(
                    ResponsiveHelper.getResponsiveSpacing(context, 12),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.today,
                    color: Colors.white,
                    size: ResponsiveHelper.getResponsiveIconSize(context, 24),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today - $dayName',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      20,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$reminderCount ${reminderCount == 1 ? 'reminder' : 'reminders'} scheduled',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getResponsiveSpacing(context, 12),
              vertical: ResponsiveHelper.getResponsiveSpacing(context, 6),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              reminderCount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayRemindersList(List<dynamic> reminders) {
    return ListView.builder(
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        final now = DateTime.now();
        final reminderTime = DateTime(
          now.year,
          now.month,
          now.day,
          reminder.time.hour,
          reminder.time.minute,
        );

        final isPast = reminderTime.isBefore(now);
        final isUpcoming = !isPast && reminderTime.difference(now).inHours < 2;

        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          margin: const EdgeInsets.only(bottom: 12),
          child: Stack(
            children: [
              ReminderCard(reminder: reminder),
              if (isPast)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              if (isUpcoming)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'SOON',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyTodayState() {
    final today = DateTime.now();
    final dayName = DayOfWeek.fromDateTime(today).fullName;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.free_breakfast,
                    size: 64,
                    color: Colors.white70,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'No Reminders for $dayName',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enjoy your free day or add some reminders!',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: widget.onNavigateToAddReminder,
            icon: const Icon(Icons.add_alarm),
            label: const Text('Add Today\'s Reminder'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
