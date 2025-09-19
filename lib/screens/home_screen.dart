import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reminder_provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/reminder_form.dart';
import '../widgets/reminder_list.dart';
import '../widgets/today_reminders_card.dart';
import '../utils/responsive_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Method to navigate to a specific tab
  void navigateToTab(int index) {
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      const ReminderForm(),
                      ReminderList(
                        onNavigateToAddReminder: () => navigateToTab(0),
                      ),
                      TodayRemindersCard(
                        onNavigateToAddReminder: () => navigateToTab(0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.isSmallScreen(context) ? 10 : 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.schedule,
                  color: Colors.white,
                  size: ResponsiveHelper.getResponsiveIconSize(context, 32),
                ),
              ),
              SizedBox(
                width: ResponsiveHelper.getResponsiveSpacing(context, 16),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remind Me',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          28,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Never miss important activities',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<ReminderProvider>(
                builder: (context, provider, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${provider.activeReminders.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: ResponsiveHelper.getResponsiveMargin(context),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(
            icon: Icon(
              Icons.add_alarm,
              size: ResponsiveHelper.getResponsiveIconSize(context, 20),
            ),
            text:
                ResponsiveHelper.isSmallScreen(context)
                    ? 'Add'
                    : 'Add Reminder',
          ),
          Tab(
            icon: Icon(
              Icons.list,
              size: ResponsiveHelper.getResponsiveIconSize(context, 20),
            ),
            text:
                ResponsiveHelper.isSmallScreen(context)
                    ? 'All'
                    : 'All Reminders',
          ),
          Tab(
            icon: Icon(
              Icons.today,
              size: ResponsiveHelper.getResponsiveIconSize(context, 20),
            ),
            text: 'Today',
          ),
        ],
      ),
    );
  }
}
