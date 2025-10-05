import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AttendanceCalcPage extends StatefulWidget {
  const AttendanceCalcPage({super.key});

  @override
  State<AttendanceCalcPage> createState() => _AttendanceCalcPageState();
}

class _AttendanceCalcPageState extends State<AttendanceCalcPage> {
  final TextEditingController _totalClassesController = TextEditingController();
  final TextEditingController _attendedClassesController = TextEditingController();
  final TextEditingController _requiredPercentageController = TextEditingController(text: "75");
  
  double currentPercentage = 0.0;
  int classesNeeded = 0;
  int classesCanMiss = 0;
  bool isCalculated = false;
  String attendanceStatus = "";

  void calculateAttendance() {
    if (_totalClassesController.text.isEmpty || 
        _attendedClassesController.text.isEmpty ||
        _requiredPercentageController.text.isEmpty) {
      _showErrorSnackbar("Please fill all fields");
      return;
    }

    try {
      int totalClasses = int.parse(_totalClassesController.text);
      int attendedClasses = int.parse(_attendedClassesController.text);
      double requiredPercentage = double.parse(_requiredPercentageController.text);

      if (attendedClasses > totalClasses) {
        _showErrorSnackbar("Attended classes cannot exceed total classes");
        return;
      }

      if (requiredPercentage < 0 || requiredPercentage > 100) {
        _showErrorSnackbar("Required percentage must be between 0-100");
        return;
      }

      setState(() {
        currentPercentage = totalClasses > 0 ? (attendedClasses / totalClasses) * 100 : 0;
        
        // Calculate classes needed to reach required percentage
        if (currentPercentage < requiredPercentage) {
          classesNeeded = ((requiredPercentage * totalClasses / 100) - attendedClasses).ceil();
          classesCanMiss = 0;
          attendanceStatus = "Below Required";
        } else {
          classesNeeded = 0;
          // Calculate how many classes can be missed while maintaining required percentage
          double maxMissable = attendedClasses - (requiredPercentage * totalClasses / 100);
          classesCanMiss = maxMissable.floor();
          if (classesCanMiss < 0) classesCanMiss = 0;
          attendanceStatus = currentPercentage >= 90 ? "Excellent" : 
                           currentPercentage >= 80 ? "Good" : "Satisfactory";
        }
        
        isCalculated = true;
      });
    } catch (e) {
      _showErrorSnackbar("Please enter valid numbers");
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFFE74C3C),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void clearAll() {
    setState(() {
      _totalClassesController.clear();
      _attendedClassesController.clear();
      _requiredPercentageController.text = "75";
      currentPercentage = 0.0;
      classesNeeded = 0;
      classesCanMiss = 0;
      isCalculated = false;
      attendanceStatus = "";
    });
  }

  Color getPercentageColor(double percentage) {
    if (percentage >= 90) return Color(0xFF50C878); // Green
    if (percentage >= 80) return Color(0xFFFFD700); // Golden
    if (percentage >= 75) return Color(0xFFFF6B35); // Orange
    return Color(0xFFE74C3C); // Red
  }

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
                  // Attendance Calc icon and title matching homepage style
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFD2691E), // Brown/orange like homepage
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calculate,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Attendance Calc",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Input Card
                    Container(
                      padding: EdgeInsets.all(25),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Icons.input,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Enter Details",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 25),
                          
                          // Total Classes Input
                          _buildInputField(
                            controller: _totalClassesController,
                            label: "Total Classes Conducted",
                            hint: "Enter total number of classes",
                            icon: Icons.school,
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Attended Classes Input
                          _buildInputField(
                            controller: _attendedClassesController,
                            label: "Classes Attended",
                            hint: "Enter classes you attended",
                            icon: Icons.check_circle,
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Required Percentage Input
                          _buildInputField(
                            controller: _requiredPercentageController,
                            label: "Required Percentage",
                            hint: "Enter minimum required %",
                            icon: Icons.percent,
                            suffix: "%",
                          ),
                          
                          SizedBox(height: 25),
                          
                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  label: "Calculate",
                                  color: Color(0xFFD2691E),
                                  icon: Icons.calculate,
                                  onTap: calculateAttendance,
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: _buildActionButton(
                                  label: "Clear All",
                                  color: Color(0xFF6C7B7F),
                                  icon: Icons.clear_all,
                                  onTap: clearAll,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Results Card
                    if (isCalculated) ...[
                      Container(
                        padding: EdgeInsets.all(25),
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
                            // Results Header
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: getPercentageColor(currentPercentage),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.analytics,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  "Results",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 20),
                            
                            // Current Percentage Card
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: getPercentageColor(currentPercentage).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: getPercentageColor(currentPercentage),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Current Attendance",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "${currentPercentage.toStringAsFixed(1)}%",
                                        style: TextStyle(
                                          color: getPercentageColor(currentPercentage),
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        attendanceStatus,
                                        style: TextStyle(
                                          color: getPercentageColor(currentPercentage),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(height: 20),
                            
                            // Additional Info Cards
                            Row(
                              children: [
                                if (classesNeeded > 0) ...[
                                  Expanded(
                                    child: _buildInfoCard(
                                      title: "Classes Needed",
                                      value: classesNeeded.toString(),
                                      color: Color(0xFFE74C3C),
                                      icon: Icons.add_circle,
                                    ),
                                  ),
                                ] else ...[
                                  Expanded(
                                    child: _buildInfoCard(
                                      title: "Can Miss",
                                      value: classesCanMiss.toString(),
                                      color: Color(0xFF50C878),
                                      icon: Icons.remove_circle,
                                    ),
                                  ),
                                ],
                                
                                SizedBox(width: 15),
                                
                                Expanded(
                                  child: _buildInfoCard(
                                    title: "Classes Left",
                                    value: "${int.parse(_totalClassesController.text) - int.parse(_attendedClassesController.text)}",
                                    color: Color(0xFF4A90E2),
                                    icon: Icons.pending,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF3a3a54),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            cursorColor: Color(0xFFD2691E),
            style: TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
              prefixIcon: Icon(icon, color: Colors.white70, size: 20),
              suffixText: suffix,
              suffixStyle: TextStyle(color: Colors.white70, fontSize: 16),
              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _totalClassesController.dispose();
    _attendedClassesController.dispose();
    _requiredPercentageController.dispose();
    super.dispose();
  }
}
