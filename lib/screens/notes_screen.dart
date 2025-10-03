import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/note_card.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedFilter = 0;

  final List<String> _filters = ['All', 'OOP', 'DSA', 'DBMS', 'DLD'];

  final List<Map<String, dynamic>> _notes = [
    {
      'title': 'Object Oriented Programming - Unit 1',
      'subject': 'OOP',
      'size': '2.4 MB',
      'author': 'Rahul Sharma',
      'time': '2 days ago',
      'color': AppTheme.primaryColor,
    },
    {
      'title': 'Data Structures - Linked Lists',
      'subject': 'DSA',
      'size': '1.8 MB',
      'author': 'You',
      'time': '5 days ago',
      'color': AppTheme.secondaryColor,
    },
    {
      'title': 'Database Normalization Notes',
      'subject': 'DBMS',
      'size': '956 KB',
      'author': 'Priya Patel',
      'time': '1 week ago',
      'color': AppTheme.accentColor,
    },
    {
      'title': 'Boolean Algebra Fundamentals',
      'subject': 'DLD',
      'size': '1.2 MB',
      'author': 'You',
      'time': '3 days ago',
      'color': AppTheme.warningColor,
    },
  ];

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

  List<Map<String, dynamic>> get _filteredNotes {
    if (_selectedFilter == 0) return _notes;
    return _notes.where((note) => note['subject'] == _filters[_selectedFilter]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Study Notes',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryTextColor,
                            ),
                          ),
                          Text(
                            'Your digital library',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.surfaceColor,
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('24', 'Total Notes', AppTheme.primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard('18', 'AI Summaries', AppTheme.secondaryColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard('5', 'Subjects', AppTheme.accentColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Filter Tabs
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFilter = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedFilter == index
                                  ? AppTheme.primaryColor
                                  : AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: _selectedFilter == index
                                    ? AppTheme.primaryColor
                                    : Colors.transparent,
                              ),
                            ),
                            child: Text(
                              _filters[index],
                              style: TextStyle(
                                color: _selectedFilter == index
                                    ? Colors.white
                                    : AppTheme.secondaryTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Notes List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = _filteredNotes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: NoteCard(
                          title: note['title'],
                          subject: note['subject'],
                          size: note['size'],
                          author: note['author'],
                          time: note['time'],
                          color: note['color'],
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}