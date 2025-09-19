import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:provider/provider.dart';
import '../models/enums.dart';
import '../providers/reminder_provider.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/time_picker_widget.dart';
import '../utils/error_handler.dart';
import '../utils/responsive_helper.dart';

class ReminderForm extends StatefulWidget {
  const ReminderForm({super.key});

  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ResponsiveContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 20),
              ),
              _buildFormCard(),
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 20),
              ),
              _buildAddButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 12,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: ResponsiveHelper.getResponsivePadding(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.white.withOpacity(0.95)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('When?', Icons.calendar_today),
            SizedBox(
              height: ResponsiveHelper.getResponsiveSpacing(context, 16),
            ),
            Consumer<ReminderProvider>(
              builder: (context, provider, child) {
                return CustomDropdown<DayOfWeek>(
                  hint: 'Select Day of Week',
                  value: provider.selectedDay,
                  items:
                      DayOfWeek.values
                          .map(
                            (day) => DropdownMenuItem(
                              value: day,
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        day.shortName,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    day.fullName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: provider.setSelectedDay,
                );
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('What Time?', Icons.access_time),
            const SizedBox(height: 16),
            const TimePickerWidget(),
            const SizedBox(height: 24),
            _buildSectionTitle('Activity', Icons.task_alt),
            const SizedBox(height: 16),
            Consumer<ReminderProvider>(
              builder: (context, provider, child) {
                return CustomDropdown<Activity>(
                  hint: 'Select Activity',
                  value: provider.selectedActivity,
                  items:
                      Activity.values
                          .map(
                            (activity) => DropdownMenuItem(
                              value: activity,
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: _getActivityColor(
                                        activity,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        activity.emoji,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          activity.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          activity.description,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: provider.setSelectedActivity,
                );
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Sound', Icons.volume_up),
            const SizedBox(height: 16),
            Consumer<ReminderProvider>(
              builder: (context, provider, child) {
                return CustomDropdown<SoundType>(
                  hint: 'Select Sound',
                  value: provider.selectedSound,
                  items:
                      SoundType.values
                          .map(
                            (sound) => DropdownMenuItem(
                              value: sound,
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _getSoundIcon(sound),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      provider.getSoundDisplayName(sound),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.play_arrow),
                                    onPressed: () async {
                                      try {
                                        await provider.previewSound(sound);
                                      } catch (e) {
                                        ErrorHandler.handleException(
                                          context,
                                          e,
                                        );
                                      }
                                    },
                                    tooltip: 'Preview Sound',
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: provider.setSelectedSound,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: ResponsiveHelper.getResponsiveIconSize(context, 24),
        ),
        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 8)),
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Consumer<ReminderProvider>(
      builder: (context, provider, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: ElevatedButton(
            onPressed:
                provider.canAddReminder && !provider.isLoading
                    ? () => _addReminder(context)
                    : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: provider.canAddReminder ? 8 : 0,
              backgroundColor:
                  provider.canAddReminder
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300,
            ),
            child:
                provider.isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_alarm,
                          size: 24,
                          color:
                              provider.canAddReminder
                                  ? Colors.white
                                  : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Add Reminder',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                provider.canAddReminder
                                    ? Colors.white
                                    : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }

  Color _getActivityColor(Activity activity) {
    switch (activity) {
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

  IconData _getSoundIcon(SoundType soundType) {
    switch (soundType) {
      case SoundType.chime:
        return Icons.notifications;
      case SoundType.bell:
        return Icons.notifications_active;
      case SoundType.alarm:
        return Icons.alarm;
      case SoundType.silent:
        return Icons.notifications_off;
    }
  }

  Future<void> _addReminder(BuildContext context) async {
    final provider = Provider.of<ReminderProvider>(context, listen: false);

    try {
      await provider.addReminder();

      if (mounted) {
        ErrorHandler.showSuccessSnackBar(
          context,
          'Reminder added successfully!',
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleException(context, e);
      }
    }
  }
}
