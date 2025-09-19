import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reminder_provider.dart';
import '../models/enums.dart';
import '../widgets/reminder_card.dart';
import '../utils/responsive_helper.dart';

class ReminderList extends StatefulWidget {
  final VoidCallback? onNavigateToAddReminder;

  const ReminderList({super.key, this.onNavigateToAddReminder});

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  ReminderStatus? _filterStatus;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Consumer<ReminderProvider>(
        builder: (context, provider, child) {
          final filteredReminders = _getFilteredReminders(provider.reminders);

          if (filteredReminders.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(provider),
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 20),
              ),
              Expanded(child: _buildRemindersList(filteredReminders)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(ReminderProvider provider) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getResponsiveSpacing(context, 12),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.list_alt,
              color: Colors.white,
              size: ResponsiveHelper.getResponsiveIconSize(context, 24),
            ),
          ),
          SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Reminders',
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
                  '${provider.activeReminders.length} active reminders',
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
          if (provider.reminders.isNotEmpty)
            Row(
              children: [
                if (_filterStatus != null)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _filterStatus = null;
                      });
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: ResponsiveHelper.getResponsiveIconSize(context, 24),
                    ),
                    tooltip: 'Clear Filter',
                  ),
                IconButton(
                  onPressed: () => _showFilterDialog(context),
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: Colors.white,
                        size: ResponsiveHelper.getResponsiveIconSize(
                          context,
                          24,
                        ),
                      ),
                      if (_filterStatus != null)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  tooltip: 'Filter Reminders',
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<dynamic> _getFilteredReminders(List<dynamic> reminders) {
    if (_filterStatus == null) {
      return reminders;
    }
    return reminders
        .where((reminder) => reminder.status == _filterStatus)
        .toList();
  }

  Widget _buildRemindersList(List<dynamic> reminders) {
    final groupedReminders = _groupRemindersByDay(reminders);

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsiveSpacing(context, 8),
      ),
      itemCount: groupedReminders.length,
      itemBuilder: (context, index) {
        final day = groupedReminders.keys.elementAt(index);
        final dayReminders = groupedReminders[day]!;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final slideAnimation = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                  index * 0.1,
                  (index * 0.1) + 0.5,
                  curve: Curves.easeOutCubic,
                ),
              ),
            );

            return SlideTransition(
              position: slideAnimation,
              child: _buildDaySection(day, dayReminders),
            );
          },
        );
      },
    );
  }

  Widget _buildDaySection(DayOfWeek day, List<dynamic> reminders) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getResponsiveSpacing(context, 16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getResponsiveSpacing(context, 16),
              vertical: ResponsiveHelper.getResponsiveSpacing(context, 8),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              day.fullName,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 12)),
          ...reminders.map(
            (reminder) => Padding(
              padding: EdgeInsets.only(
                bottom: ResponsiveHelper.getResponsiveSpacing(context, 8),
              ),
              child: ReminderCard(reminder: reminder),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getResponsiveSpacing(context, 32),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.alarm_off,
              size: ResponsiveHelper.getResponsiveIconSize(context, 64),
              color: Colors.white70,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 24)),
          Text(
            'No Reminders Yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 24),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 8)),
          Text(
            'Create your first reminder to get started',
            style: TextStyle(
              color: Colors.white70,
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 32)),
          ElevatedButton.icon(
            onPressed: widget.onNavigateToAddReminder,
            icon: Icon(
              Icons.add,
              size: ResponsiveHelper.getResponsiveIconSize(context, 20),
            ),
            label: Text(
              'Add Reminder',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsiveSpacing(context, 24),
                vertical: ResponsiveHelper.getResponsiveSpacing(context, 12),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<DayOfWeek, List<dynamic>> _groupRemindersByDay(List<dynamic> reminders) {
    final Map<DayOfWeek, List<dynamic>> grouped = {};

    for (final day in DayOfWeek.values) {
      final dayReminders =
          reminders.where((reminder) => reminder.dayOfWeek == day).toList();

      if (dayReminders.isNotEmpty) {
        dayReminders.sort((a, b) => a.time.hour.compareTo(b.time.hour));
        grouped[day] = dayReminders;
      }
    }

    return grouped;
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Filter Reminders'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.list,
                    color:
                        _filterStatus == null
                            ? Theme.of(context).primaryColor
                            : null,
                  ),
                  title: const Text('Show All'),
                  trailing:
                      _filterStatus == null ? const Icon(Icons.check) : null,
                  onTap: () {
                    setState(() {
                      _filterStatus = null;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color:
                        _filterStatus == ReminderStatus.active
                            ? Colors.green
                            : null,
                  ),
                  title: const Text('Active Only'),
                  trailing:
                      _filterStatus == ReminderStatus.active
                          ? const Icon(Icons.check)
                          : null,
                  onTap: () {
                    setState(() {
                      _filterStatus = ReminderStatus.active;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.pause_circle,
                    color:
                        _filterStatus == ReminderStatus.cancelled
                            ? Colors.orange
                            : null,
                  ),
                  title: const Text('Paused Only'),
                  trailing:
                      _filterStatus == ReminderStatus.cancelled
                          ? const Icon(Icons.check)
                          : null,
                  onTap: () {
                    setState(() {
                      _filterStatus = ReminderStatus.cancelled;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.done_all,
                    color:
                        _filterStatus == ReminderStatus.completed
                            ? Colors.blue
                            : null,
                  ),
                  title: const Text('Completed Only'),
                  trailing:
                      _filterStatus == ReminderStatus.completed
                          ? const Icon(Icons.check)
                          : null,
                  onTap: () {
                    setState(() {
                      _filterStatus = ReminderStatus.completed;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
