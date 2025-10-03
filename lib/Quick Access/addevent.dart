// import 'package:flutter/material.dart';
// import 'package:studymate_main/screens/homescreen.dart';
// import 'package:table_calendar/table_calendar.dart';

// /// ✅ Event Model
// class Event {
//   final String eventName;
//   final String eventDate;
//   final String eventTime;
//   final String? eventDescription;

//   Event({
//     required this.eventName,
//     required this.eventDate,
//     required this.eventTime,
//     this.eventDescription,
//   });

//   @override
//   String toString() {
//     return 'Event(name: $eventName, date: $eventDate, time: $eventTime, description: $eventDescription)';
//   }
// }

// class AddEventScreen extends StatefulWidget {
//   const AddEventScreen({super.key});

//   @override
//   State<AddEventScreen> createState() => _AddEventScreenState();
// }

// class _AddEventScreenState extends State<AddEventScreen> {
//   // Controllers
//   final TextEditingController _nameCtrl = TextEditingController();
//   final TextEditingController _dateCtrl = TextEditingController();
//   final TextEditingController _timeCtrl = TextEditingController();
//   final TextEditingController _descCtrl = TextEditingController();

//   // Calendar & Time Variables
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   TimeOfDay? _selectedTime;

//   // Visibility toggles
//   bool _showCalendar = false;

//   // Store events
//   final List<Event> _events = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: const Text("Add Event", style: TextStyle(color: Colors.white)),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Event Name
//             const SizedBox(height: 17),
//             const Text(
//               "   Name of the Event",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.only(top: 12.0, left: 10, right: 10),
//               child: buildGlass(
//                 child: Container(
//                   height: 50,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: TextField(
//                     controller: _nameCtrl,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: "        Enter Event",
//                       hintStyle: TextStyle(color: Colors.white60),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // Event Date
//             SizedBox(height: 15),
//             Text(
//               "    Event Date",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.only(top: 12.0, left: 10, right: 10),
//               child: buildGlass(
//                 child: Container(
//                   height: 50,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: TextField(
//                     controller: _dateCtrl,
//                     readOnly: true,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: "        Select Date",
//                       hintStyle: const TextStyle(color: Colors.white60),

//                       suffixIcon: IconButton(
//                         icon: const Icon(
//                           Icons.calendar_today,
//                           color: Color.fromARGB(255, 249, 246, 246),
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _showCalendar = !_showCalendar;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // Calendar Visibility
//             Visibility(
//               visible: _showCalendar,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: buildGlass(
//                   child: TableCalendar(
//                     firstDay: DateTime.utc(2020, 1, 1),
//                     lastDay: DateTime.utc(2030, 12, 31),
//                     focusedDay: _focusedDay,
//                     selectedDayPredicate: (day) {
//                       return isSameDay(_selectedDay, day);
//                     },
//                     onDaySelected: (selectedDay, focusedDay) {
//                       setState(() {
//                         _selectedDay = selectedDay;
//                         _focusedDay = focusedDay;
//                         _dateCtrl.text =
//                             "${selectedDay.day}/${selectedDay.month}/${selectedDay.year}";
//                         _showCalendar = false; // auto close after selecting
//                       });
//                     },
//                     calendarFormat: CalendarFormat.month,
//                     headerStyle: const HeaderStyle(
//                       formatButtonVisible: false,
//                       titleCentered: true,
//                       titleTextStyle: TextStyle(color: Colors.white),
//                       leftChevronIcon: Icon(
//                         Icons.chevron_left,
//                         color: Colors.white,
//                       ),
//                       rightChevronIcon: Icon(
//                         Icons.chevron_right,
//                         color: Colors.white,
//                       ),
//                     ),
//                     calendarStyle: const CalendarStyle(

//                       defaultTextStyle: TextStyle(color: Colors.white),
//                       weekendTextStyle: TextStyle(color: Colors.white),
//                       todayTextStyle: TextStyle(
//                         color: Colors.deepOrange,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       selectedTextStyle: TextStyle(
//                         color: Colors.deepOrange,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       outsideTextStyle: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // Event Time
//             const SizedBox(height: 20),
//             const Text(
//               "    Event Time",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.only(top: 12.0, left: 10, right: 10),
//               child: buildGlass(
//                 child: Container(
//                   height: 50,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: TextField(
//                     controller: _timeCtrl,
//                     readOnly: true,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: "        Select Time",
//                       hintStyle: const TextStyle(color: Colors.white60),
//                       suffixIcon: IconButton(
//                         icon: const Icon(
//                           Icons.access_time,
//                           color: Colors.white70,
//                         ),
//                         onPressed: () async {
//                           final TimeOfDay? picked = await showTimePicker(
//                             context: context,
//                             initialTime: TimeOfDay.now(),
//                           );
//                           if (picked != null) {
//                             setState(() {
//                               _selectedTime = picked;
//                               _timeCtrl.text = picked.format(context);
//                             });
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // Event Description
//             const SizedBox(height: 20),
//             const Text(
//               "    Event Description (Optional)",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.only(top: 12.0, left: 10, right: 10),
//               child: buildGlass(
//                 child: Container(
//                   height: 80,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: TextField(
//                     controller: _descCtrl,
//                     maxLines: 3,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: "        Enter Description",
//                       hintStyle: TextStyle(color: Colors.white60),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // Submit Button
//             const SizedBox(height: 30),
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepOrange,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 40,
//                     vertical: 15,
//                   ),
//                 ),
//                 onPressed: () {
//                   if (_nameCtrl.text.isEmpty ||
//                       _dateCtrl.text.isEmpty ||
//                       _timeCtrl.text.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("Please fill all required fields"),
//                       ),
//                     );
//                     return;
//                   }

//                   Event newEvent = Event(
//                     eventName: _nameCtrl.text,
//                     eventDate: _dateCtrl.text,
//                     eventTime: _timeCtrl.text,
//                     eventDescription:
//                         _descCtrl.text.isNotEmpty ? _descCtrl.text : null,
//                   );

//                   setState(() {
//                     _events.add(newEvent);
//                   });

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text("Event Added: ${newEvent.toString()}"),
//                     ),
//                   );

//                   _nameCtrl.clear();
//                   _dateCtrl.clear();
//                   _timeCtrl.clear();
//                   _descCtrl.clear();
//                   _selectedDay = null;
//                   _selectedTime = null;
//                 },
//                 child: const Text(
//                   "Submit",
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             // Stored Events
          
//             ..._events.map(
//               (e) => ListTile(
//                 leading: const Icon(Icons.event, color: Colors.white),
//                 title: Text(
//                   e.eventName,
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 subtitle: Text(
//                   "${e.eventDate} at ${e.eventTime}\n${e.eventDescription ?? ""}",
//                   style: const TextStyle(color: Colors.white70),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }










import 'package:flutter/material.dart';
import 'package:study_mate_app/auth/login.dart';
import 'package:table_calendar/table_calendar.dart';

/// ✅ Event Model
class Event {
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String? eventDescription;

  Event({
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    this.eventDescription,
  });

  @override
  String toString() {
    return 'Event(name: $eventName, date: $eventDate, time: $eventTime, description: $eventDescription)';
  }
}

/// ========================= ADD EVENT SCREEN =========================
class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  // Controllers
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _timeCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  // Calendar & Time Variables
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _selectedTime;

  // Visibility toggle
  bool _showCalendar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Add Event", style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/background.jpg"))
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                // ---------------- Event Name ----------------
                const SizedBox(height: 17),
                const Text(
                  "   Name of the Event",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 10, right: 10),
                  child: buildGlass(
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _nameCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "        Enter Event",
                          hintStyle: TextStyle(color: Colors.white60),
                        ),
                      ),
                    ),
                  ),
                ),
          
                // ---------------- Event Date ----------------
                const SizedBox(height: 20),
                const Text(
                  "   Event Date",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 10, right: 10),
                  child: buildGlass(
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _dateCtrl,
                        readOnly: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "        Select Date",
                          hintStyle: const TextStyle(color: Colors.white60),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today,
                                color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _showCalendar = !_showCalendar;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          
                // Calendar Visibility
                Visibility(
                  visible: _showCalendar,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildGlass(
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            _dateCtrl.text =
                                "${selectedDay.day}/${selectedDay.month}/${selectedDay.year}";
                            _showCalendar = false;
                          });
                        },
                        calendarStyle: const CalendarStyle(
                          defaultTextStyle: TextStyle(color: Colors.white),
                          weekendTextStyle: TextStyle(color: Colors.white),
                          todayDecoration: BoxDecoration(
                            color: Colors.deepOrange,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            shape: BoxShape.circle,
                          ),
                          outsideTextStyle: TextStyle(color: Colors.grey),
                        ),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(color: Colors.white),
                          leftChevronIcon:
                              Icon(Icons.chevron_left, color: Colors.white),
                          rightChevronIcon:
                              Icon(Icons.chevron_right, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
          
                // ---------------- Event Time ----------------
                const SizedBox(height: 20),
                const Text(
                  "   Event Time",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 10, right: 10),
                  child: buildGlass(
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _timeCtrl,
                        readOnly: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "        Select Time",
                          hintStyle: const TextStyle(color: Colors.white60),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.access_time,
                                color: Colors.white70),
                            onPressed: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  _selectedTime = picked;
                                  _timeCtrl.text = picked.format(context);
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          
                // ---------------- Event Description ----------------
                const SizedBox(height: 20),
                const Text(
                  "   Event Description (Optional)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 10, right: 10),
                  child: buildGlass(
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _descCtrl,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "        Enter Description",
                          hintStyle: TextStyle(color: Colors.white60),
                        ),
                      ),
                    ),
                  ),
                ),
          
                // ---------------- Submit Button ----------------
                const SizedBox(height: 30),
                Center(
                  child: buildGlass1(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(180, 60),
                        backgroundColor: const Color.fromARGB(255, 255, 95, 252).withOpacity(0.12),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      onPressed: () {
                        if (_nameCtrl.text.isEmpty ||
                            _dateCtrl.text.isEmpty ||
                            _timeCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all required fields"),
                            ),
                          );
                          return;
                        }
                              
                        Event newEvent = Event(
                          eventName: _nameCtrl.text,
                          eventDate: _dateCtrl.text,
                          eventTime: _timeCtrl.text,
                          eventDescription:
                              _descCtrl.text.isNotEmpty ? _descCtrl.text : null,
                        );
                              
                        Navigator.pop(context, newEvent);
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
