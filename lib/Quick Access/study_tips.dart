
import 'package:flutter/material.dart';

class StudyTipsPage extends StatelessWidget {
  const StudyTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Same dark background as homepage
      backgroundColor: Color(0xFF1a1a2e),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 10),
                  // Study Tips icon and title matching homepage style
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFD700), // Golden yellow like homepage
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.lightbulb,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Study Tips",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Study Tips Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Tip 1 - Time Management
                  StudyTipCard(
                    icon: Icons.schedule,
                    iconColor: Color(0xFFFF6B35), // Orange
                    title: "Time Management",
                    description: "Use the Pomodoro Technique: Study for 25 minutes, then take a 5-minute break.",
                    tips: [
                      "Set specific study goals for each session",
                      "Use timers to track your study periods",
                      "Take regular breaks to maintain focus",
                      "Plan your study schedule in advance"
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Tip 2 - Active Learning
                  StudyTipCard(
                    icon: Icons.psychology,
                    iconColor: Color(0xFF4A90E2), // Blue
                    title: "Active Learning",
                    description: "Engage with the material actively rather than passive reading.",
                    tips: [
                      "Take handwritten notes while reading",
                      "Explain concepts out loud to yourself",
                      "Create mind maps for complex topics",
                      "Practice retrieval by testing yourself"
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Tip 3 - Environment Setup
                  StudyTipCard(
                    icon: Icons.home,
                    iconColor: Color(0xFF50C878), // Green
                    title: "Study Environment",
                    description: "Create a dedicated, distraction-free study space.",
                    tips: [
                      "Keep your study area clean and organized",
                      "Ensure good lighting and comfortable seating",
                      "Remove distracting items from your workspace",
                      "Use noise-cancelling headphones if needed"
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Tip 4 - Memory Techniques
                  StudyTipCard(
                    icon: Icons.memory,
                    iconColor: Color(0xFF9B59B6), // Purple
                    title: "Memory Techniques",
                    description: "Use proven methods to improve information retention.",
                    tips: [
                      "Create acronyms for lists and sequences",
                      "Use visualization and association techniques",
                      "Practice spaced repetition for long-term memory",
                      "Connect new information to existing knowledge"
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Tip 5 - Health & Wellness
                  StudyTipCard(
                    icon: Icons.favorite,
                    iconColor: Color(0xFFE74C3C), // Red
                    title: "Health & Wellness",
                    description: "Maintain your physical and mental well-being while studying.",
                    tips: [
                      "Get 7-9 hours of sleep each night",
                      "Stay hydrated and eat nutritious meals",
                      "Exercise regularly to boost brain function",
                      "Practice stress management techniques"
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Tip 6 - Goal Setting
                  StudyTipCard(
                    icon: Icons.flag,
                    iconColor: Color(0xFFFFD700), // Golden yellow
                    title: "Goal Setting",
                    description: "Set clear, achievable goals to stay motivated and focused.",
                    tips: [
                      "Break large tasks into smaller, manageable chunks",
                      "Set both short-term and long-term goals",
                      "Track your progress regularly",
                      "Reward yourself when you achieve milestones"
                    ],
                  ),
                  
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget for study tip cards matching homepage style
class StudyTipCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final List<String> tips;

  const StudyTipCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.tips,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF2d2d44), // Same card color as homepage
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Title row (matching homepage cards)
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 15),
          
          // Description
          Text(
            description,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          
          SizedBox(height: 15),
          
          // Tips list
          ...tips.map((tip) => Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8, right: 10),
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tip,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
        ],
      ),
    );
  }
}
