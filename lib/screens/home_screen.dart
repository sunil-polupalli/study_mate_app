import 'package:flutter/material.dart';
import 'package:study_mate_app/Quick%20Access/attendence.dart';
import 'package:study_mate_app/Quick%20Access/eventscheduler.dart';
import 'package:study_mate_app/Quick%20Access/group/class_room.dart';
import 'package:study_mate_app/Quick%20Access/study_tips.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/quick_access_card.dart';
import '../widgets/study_tool_card.dart';
import '../widgets/activity_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
    return Scaffold(
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'StudyMate',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryTextColor,
                                ),
                      ),
                      // CircleAvatar(
                      //   radius: 22,
                      //   backgroundColor: AppTheme.primaryColor,
                      //   child: Icon(
                      //     Icons.person_rounded,
                      //     color: Colors.white,
                      //     size: 24,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Exam Countdown Card
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.accentColor,
                          AppTheme.accentColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Next Exam',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Digital Logic & Design',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const CountdownTimer(),
                        const SizedBox(height: 16),
                        Text(
                          "You've got this! Stay focused.",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Quick Access Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quick Access',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        'Jump into your study session',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      QuickAccessCard(
                        title: 'Notes',
                        icon: Icons.groups_rounded,
                        color: AppTheme.secondaryColor,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClassRoom(),
                              ));
                        },
                      ),
                      QuickAccessCard(
                        title: 'Scheduler',
                        icon: Icons.cloud_upload_rounded,
                        color: AppTheme.primaryColor,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventSchedulerScreen(),
                              ));
                        },
                      ),
                      QuickAccessCard(
                        title: 'Attendence Calc',
                        icon: Icons.quiz_rounded,
                        color: AppTheme.accentColor,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Attendence(),
                              ));
                        },
                      ),
                      QuickAccessCard(
                        title: 'Study Tips',
                        icon: Icons.chat_bubble_rounded,
                        color: AppTheme.warningColor,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudyTips(),
                              ));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Study Tools Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Study Tools',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        'Track your academic progress',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: StudyToolCard(
                          title: 'CGPA Calculator',
                          subtitle: 'Current: 8.4/10',
                          icon: Icons.calculate_rounded,
                          color: const Color(0xFF4F46E5),
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StudyToolCard(
                          title: 'Attendance',
                          subtitle: '85% Overall',
                          icon: Icons.calendar_today_rounded,
                          color: AppTheme.successColor,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Recent Activity Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        'View All',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Column(
                    children: [
                      ActivityItem(
                        icon: Icons.note_add_rounded,
                        title: 'Uploaded notes for OOPS',
                        time: '2 hours ago',
                        iconColor: AppTheme.primaryColor,
                      ),
                      SizedBox(height: 12),
                      ActivityItem(
                        icon: Icons.groups_rounded,
                        title: 'Joined DSA Study Group',
                        time: '5 hours ago',
                        iconColor: AppTheme.secondaryColor,
                      ),
                      SizedBox(height: 12),
                      ActivityItem(
                        icon: Icons.psychology_rounded,
                        title: 'Generated AI summary',
                        time: '1 day ago',
                        iconColor: AppTheme.warningColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
