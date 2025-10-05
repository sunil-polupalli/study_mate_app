import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchedulerPage extends StatefulWidget {
  const SchedulerPage({super.key});

  @override
  State<SchedulerPage> createState() => _SchedulerPageState();
}

class _SchedulerPageState extends State<SchedulerPage> {
  DateTime selectedDate = DateTime.now();
  List<ScheduleItem> scheduleItems = [];
  
  // Sample data - in real app, this would come from database
  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    final today = DateTime.now();
    scheduleItems = [
      ScheduleItem(
        id: '1',
        title: 'Study Session',
        description: 'Review OOPS concept for tomorrow\'s test',
        startTime: DateTime(today.year, today.month, today.day, 15, 0),
        endTime: DateTime(today.year, today.month, today.day, 17, 0),
        type: ScheduleType.study,
      ),
    ];
  }

  List<ScheduleItem> getItemsForDate(DateTime date) {
    return scheduleItems.where((item) {
      return item.startTime.year == date.year &&
             item.startTime.month == date.month &&
             item.startTime.day == date.day;
    }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  void _showAddScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AddScheduleDialog(
        selectedDate: selectedDate,
        onAdd: (item) {
          setState(() {
            scheduleItems.add(item);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todayItems = getItemsForDate(selectedDate);
    
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
                  // Scheduler icon and title matching homepage style
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF9B59B6), // Purple like homepage
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.schedule,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Scheduler",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: _showAddScheduleDialog,
                    icon: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF9B59B6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Calendar Header Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF2d2d44),
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
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFF4A90E2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Today's Schedule",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 15),
                  
                  // Date Display
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFF9B59B6).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Color(0xFF9B59B6), width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.today,
                          color: Color(0xFF9B59B6),
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          DateFormat('EEEE, MMMM d, y').format(selectedDate),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 15),
                  
                  // Quick Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: "Total Events",
                          value: todayItems.length.toString(),
                          color: Color(0xFF4A90E2),
                          icon: Icons.event,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          title: "Lectures",
                          value: todayItems.where((item) => item.type == ScheduleType.lecture).length.toString(),
                          color: Color(0xFF50C878),
                          icon: Icons.school,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          title: "Assignments",
                          value: todayItems.where((item) => item.type == ScheduleType.assignment).length.toString(),
                          color: Color(0xFFE74C3C),
                          icon: Icons.assignment,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Schedule List
            Expanded(
              child: todayItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: todayItems.length,
                      itemBuilder: (context, index) {
                        return ScheduleItemCard(
                          item: todayItems[index],
                          onEdit: () {
                            // Handle edit
                          },
                          onDelete: () {
                            setState(() {
                              scheduleItems.remove(todayItems[index]);
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Color(0xFF2d2d44),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF9B59B6).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_month,
                size: 60,
                color: Color(0xFF9B59B6),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "No Events Today",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Tap the + button to add your first event",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Schedule Item Model
class ScheduleItem {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final ScheduleType type;

  ScheduleItem({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
  });
}

enum ScheduleType { lecture, lab, study, assignment, exam, meeting }

// Schedule Item Card Widget
class ScheduleItemCard extends StatelessWidget {
  final ScheduleItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ScheduleItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  Color getTypeColor(ScheduleType type) {
    switch (type) {
      case ScheduleType.lecture:
        return Color(0xFF4A90E2);
      case ScheduleType.lab:
        return Color(0xFF50C878);
      case ScheduleType.study:
        return Color(0xFF9B59B6);
      case ScheduleType.assignment:
        return Color(0xFFE74C3C);
      case ScheduleType.exam:
        return Color(0xFFFF6B35);
      case ScheduleType.meeting:
        return Color(0xFFFFD700);
    }
  }

  IconData getTypeIcon(ScheduleType type) {
    switch (type) {
      case ScheduleType.lecture:
        return Icons.school;
      case ScheduleType.lab:
        return Icons.science;
      case ScheduleType.study:
        return Icons.book;
      case ScheduleType.assignment:
        return Icons.assignment;
      case ScheduleType.exam:
        return Icons.quiz;
      case ScheduleType.meeting:
        return Icons.group;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = getTypeColor(item.type);
    final timeFormat = DateFormat('HH:mm');
    
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Color(0xFF2d2d44),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Time indicator
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: typeColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: typeColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            getTypeIcon(item.type),
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: Colors.white70, size: 20),
                          color: Color(0xFF3a3a54),
                          onSelected: (value) {
                            if (value == 'edit') onEdit();
                            if (value == 'delete') onDelete();
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.white70, size: 16),
                                  SizedBox(width: 8),
                                  Text('Edit', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red, size: 16),
                                  SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 8),
                    
                    Text(
                      item.description,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    
                    SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Icon(Icons.access_time, color: typeColor, size: 16),
                        SizedBox(width: 8),
                        Text(
                          "${timeFormat.format(item.startTime)} - ${timeFormat.format(item.endTime)}",
                          style: TextStyle(
                            color: typeColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: typeColor, width: 1),
                          ),
                          child: Text(
                            item.type.name.toUpperCase(),
                            style: TextStyle(
                              color: typeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add Schedule Dialog
class AddScheduleDialog extends StatefulWidget {
  final DateTime selectedDate;
  final Function(ScheduleItem) onAdd;

  const AddScheduleDialog({
    super.key,
    required this.selectedDate,
    required this.onAdd,
  });

  @override
  State<AddScheduleDialog> createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends State<AddScheduleDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
  ScheduleType selectedType = ScheduleType.study;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF2d2d44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add New Event",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            
            // Title field
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Color(0xFF3a3a54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 15),
            
            // Description field
            TextField(
              controller: _descController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Color(0xFF3a3a54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 15),
            
            // Type dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Color(0xFF3a3a54),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ScheduleType>(
                  value: selectedType,
                  dropdownColor: Color(0xFF3a3a54),
                  isExpanded: true,
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) => setState(() => selectedType = value!),
                  items: ScheduleType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.name.toUpperCase()),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.isNotEmpty) {
                        final item = ScheduleItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: _titleController.text,
                          description: _descController.text,
                          startTime: DateTime(
                            widget.selectedDate.year,
                            widget.selectedDate.month,
                            widget.selectedDate.day,
                            startTime.hour,
                            startTime.minute,
                          ),
                          endTime: DateTime(
                            widget.selectedDate.year,
                            widget.selectedDate.month,
                            widget.selectedDate.day,
                            endTime.hour,
                            endTime.minute,
                          ),
                          type: selectedType,
                        );
                        widget.onAdd(item);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9B59B6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}

