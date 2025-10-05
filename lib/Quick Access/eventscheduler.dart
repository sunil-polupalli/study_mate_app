// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:studymate_main/screens/addevent.dart';

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

// class EventSchedulerScreen extends StatefulWidget {
//   final List<Event> events;

//   const EventSchedulerScreen({super.key, required this.events});

//   @override
//   State<EventSchedulerScreen> createState() => _EventSchedulerScreenState();
// }

// class _EventSchedulerScreenState extends State<EventSchedulerScreen> {
//   late List<Event> _events;
//   late List<bool> _priorityFlags;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _events = List.from(widget.events);
//     _priorityFlags = List.generate(_events.length, (_) => false);

//     // Timer to update countdowns every second
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() {}); // triggers rebuild to update countdowns
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   String getCountdown(Event event) {
//     try {
//       // Parse event date & time
//       final parts = event.eventDate.split('/');
//       final day = int.parse(parts[0]);
//       final month = int.parse(parts[1]);
//       final year = int.parse(parts[2]);

//       final timeParts = event.eventTime.split(':');
//       int hour = int.parse(timeParts[0]);
//       int minute = 0;

//       if (timeParts.length > 1) {
//         minute = int.parse(timeParts[1]);
//       }

//       DateTime eventDateTime = DateTime(year, month, day, hour, minute);
//       Duration diff = eventDateTime.difference(DateTime.now());

//       if (diff.isNegative) return "Event Passed";

//       int d = diff.inDays;
//       int h = diff.inHours % 24;
//       int m = diff.inMinutes % 60;
//       int s = diff.inSeconds % 60;

//       return "$d d : $h h : $m m : $s s";
//     } catch (e) {
//       return "Invalid Date/Time";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       appBar: AppBar(
//         title: const Text("Event Scheduler"),
//         backgroundColor: Colors.deepOrange,
//       ),
//       backgroundColor: Colors.transparent,
//       body:
//           _events.isEmpty
//               ? const Center(
//                 child: Text(
//                   "No events added yet.",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               )
//               : ListView.builder(
//                 itemCount: _events.length,
//                 itemBuilder: (context, index) {
//                   final event = _events[index];
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: Colors.white.withOpacity(0.1),
//                       ),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 15,
//                           vertical: 10,
//                         ),
//                         title: Text(
//                           event.eventName,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "${event.eventDate} at ${event.eventTime}",
//                               style: const TextStyle(color: Colors.white70),
//                             ),
//                             if (event.eventDescription != null &&
//                                 event.eventDescription!.isNotEmpty)
//                               Text(
//                                 event.eventDescription!,
//                                 style: const TextStyle(color: Colors.white60),
//                               ),
//                             const SizedBox(height: 5),
//                             Text(
//                               "Countdown: ${getCountdown(event)}",
//                               style: const TextStyle(
//                                 color: Colors.deepOrangeAccent,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         trailing: IconButton(
//                           icon: Icon(
//                             _priorityFlags[index]
//                                 ? Icons.star
//                                 : Icons.star_border,
//                             color: Colors.yellowAccent,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _priorityFlags[index] = !_priorityFlags[index];
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.transparent,
//         child: Icon(Icons.add, color: Colors.white),
//         mini: true,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddEventScreen()),
//           );
//         },
//       ),
//     );
//   }
// }



// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:study_mate_app/Quick%20Access/addevent.dart';
// import 'package:study_mate_app/auth/login.dart';
// import 'package:glassmorphism/glassmorphism.dart';
// /// ========================= EVENT SCHEDULER SCREEN =========================
// class EventSchedulerScreen extends StatefulWidget {
//   const EventSchedulerScreen({super.key});

//   @override
//   State<EventSchedulerScreen> createState() => _EventSchedulerScreenState();
// }

// class _EventSchedulerScreenState extends State<EventSchedulerScreen> {
//   final List<Event> _events = [];
//   final List<bool> _priorityFlags = [];
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() {}); // update countdowns
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   String getCountdown(Event event) {
//     try {
//       final parts = event.eventDate.split('/');
//       final day = int.parse(parts[0]);
//       final month = int.parse(parts[1]);
//       final year = int.parse(parts[2]);

//       final timeParts = event.eventTime.split(':');
//       int hour = int.parse(timeParts[0]);
//       int minute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;

//       final eventDateTime = DateTime(year, month, day, hour, minute);
//       final diff = eventDateTime.difference(DateTime.now());

//       if (diff.isNegative) return "Event Passed";

//       return "${diff.inDays} d : ${diff.inHours % 24} h : ${diff.inMinutes % 60} m : ${diff.inSeconds % 60} s";
//     } catch (e) {
//       return "Invalid Date/Time";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Event Scheduler",style: TextStyle(color: Colors.white),),
//         backgroundColor: Colors.transparent,
//       ),
//       backgroundColor: Colors.transparent,
//       body: _events.isEmpty
//           ? const Center(
//               child: Text(
//                 "No events added yet.",
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             )
//           : ListView.builder(
//               itemCount: _events.length,
//               itemBuilder: (context, index) {
//                 final event = _events[index];
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: Colors.white12,
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 15,
//                         vertical: 10,
//                       ),
//                       title: Text(
//                         event.eventName,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${event.eventDate} at ${event.eventTime}",
//                             style: const TextStyle(color: Colors.white70),
//                           ),
//                           if (event.eventDescription != null &&
//                               event.eventDescription!.isNotEmpty)
//                             Text(
//                               event.eventDescription!,
//                               style: const TextStyle(color: Colors.white60),
//                             ),
//                           const SizedBox(height: 5),
//                           Text(
//                             "Countdown: ${getCountdown(event)}",
//                             style: const TextStyle(
//                               color: Colors.deepOrangeAccent,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       trailing: IconButton(
//                         icon: Icon(
//                           _priorityFlags[index] ? Icons.star : Icons.star_border,
//                           color: Colors.yellowAccent,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _priorityFlags[index] = !_priorityFlags[index];
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: buildGlass(
//         child: FloatingActionButton(
//           backgroundColor: Colors.transparent,
//           child: const Icon(Icons.add, color: Colors.white),
//           onPressed: () async {
//             final newEvent = await Navigator.push<Event>(
//               context,
//               MaterialPageRoute(builder: (context) => const AddEventScreen()),
//             );
//             if (newEvent != null) {
//               setState(() {
//                 _events.add(newEvent);
//                 _priorityFlags.add(false);
//               });
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
