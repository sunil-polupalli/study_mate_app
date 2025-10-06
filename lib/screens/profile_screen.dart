import 'package:flutter/material.dart';
import 'package:study_mate_app/auth/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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

  // Logout function with confirmation dialog
  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final confirmed = await _showLogoutConfirmationDialog();
    
    if (confirmed == true) {
      try {
        // Sign out from Supabase
        await Supabase.instance.client.auth.signOut();
        
        // Navigate to Login page and clear navigation stack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
        );
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Logged out successfully"),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        // Show error message if logout fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Logout failed: ${e.toString()}"),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // Confirmation dialog matching StudyMate theme
  Future<bool?> _showLogoutConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logout Icon
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    size: 40,
                    color: AppTheme.errorColor,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Title
                Text(
                  'Logout Confirmation',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryTextColor,
                  ),
                ),
                
                const SizedBox(height: 15),
                
                // Message
                Text(
                  'Are you sure you want to logout from StudyMate?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 25),
                
                // Action Buttons
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryTextColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppTheme.primaryTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 15),
                    
                    // Logout Button
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.errorColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
                children: [
                  // Header
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Profile Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.surfaceColor,
                          AppTheme.surfaceVariant,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.primaryColor,
                          child: Icon(
                            Icons.person_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Shanmukh',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryTextColor,
                          ),
                        ),
                        Text(
                          'Computer Science Student',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem('30', 'Notes'),
                            _buildStatItem('8.5', 'CGPA'),
                            _buildStatItem('87%', 'Attendance'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Menu Items
                  _buildMenuItem(
                    'Academic Progress',
                    Icons.trending_up_rounded,
                    AppTheme.primaryColor,
                    () {},
                  ),
                  _buildMenuItem(
                    'Study Statistics',
                    Icons.bar_chart_rounded,
                    AppTheme.secondaryColor,
                    () {},
                  ),
                  _buildMenuItem(
                    'Achievements',
                    Icons.emoji_events_rounded,
                    AppTheme.warningColor,
                    () {},
                  ),
                  _buildMenuItem(
                    'Settings',
                    Icons.settings_rounded,
                    AppTheme.accentColor,
                    () {},
                  ),
                  _buildMenuItem(
                    'Help & Support',
                    Icons.help_outline_rounded,
                    AppTheme.successColor,
                    () {},
                  ),
                  _buildMenuItem(
                    'About',
                    Icons.info_outline_rounded,
                    AppTheme.secondaryTextColor,
                    () {},
                  ),
                  
                  // Add Logout Menu Item
                  _buildMenuItem(
                    'Logout',
                    Icons.logout_rounded,
                    AppTheme.errorColor, // Use red color for logout to indicate danger
                    _handleLogout, // Call the logout function
                  ),
                  
                  const SizedBox(height: 20), // Extra spacing at bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String title, IconData icon, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.surfaceColor,
                AppTheme.surfaceVariant,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppTheme.secondaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
