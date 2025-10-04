import 'dart:io' show File, Platform;
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../theme/app_theme.dart';

class AIHelperScreen extends StatefulWidget {
  const AIHelperScreen({super.key});

  @override
  State<AIHelperScreen> createState() => _AIHelperScreenState();
}

class _AIHelperScreenState extends State<AIHelperScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _messageController = TextEditingController();

  final String _geminiApiKey = 'AIzaSyCLdYo19zOp7a4lNoagfMRnSUSr8BUGPjo';
  final String _geminiEndpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  List<Map<String, String>> messages = [
    {
      'sender': 'AI',
      'text': "Hi! I'm your AI study assistant. I can help you with summaries, explanations, practice questions, and more. What would you like to study today?",
      'time': _getCurrentTime(),
    }
  ];

  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? attachedFile;
  String? selectedFeature; // To highlight tapped feature

  static String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  final List<Map<String, dynamic>> _features = [
    {
      'title': 'Summarize',
      'icon': Icons.article,
      'color': Colors.deepPurple,
    },
    {
      'title': 'Explain',
      'icon': Icons.lightbulb,
      'color': Colors.amber,
    },
    {
      'title': 'Practice',
      'icon': Icons.bar_chart,
      'color': Colors.blue,
    },
    {
      'title': 'Study Tips',
      'icon': Icons.tips_and_updates,
      'color': Colors.green,
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
    _messageController.dispose();
    super.dispose();
  }

  Future<bool> requestStoragePermission() async {
    if (kIsWeb) return true;
    if (Platform.isAndroid || Platform.isIOS) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
    return true;
  }

  Future<void> pickFile() async {
    setState(() { errorMessage = null; });
    bool granted = await requestStoragePermission();
    if (!granted) {
      setState(() { errorMessage = 'Storage permission denied.'; });
      return;
    }
    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(allowMultiple: false);
    } catch (e) {
      setState(() { errorMessage = 'File picker error: $e'; });
      return;
    }
    if (result == null) {
      setState(() { errorMessage = 'No file selected.'; });
      return;
    }
    final file = result.files.single;
    setState(() {
      attachedFile = {
        'name': file.name,
        'extension': file.extension ?? 'unknown',
        'bytes': file.bytes,
        'path': file.path,
      };
      // Show an attachment message only once, not as chat send
      messages.add({
        'sender': 'User',
        'text': '📎 Attached file: ${file.name} (${file.extension ?? "unknown"})',
        'time': _getCurrentTime(),
      });
      errorMessage = null;
    });
  }

  void clearAttachment() {
    setState(() {
      attachedFile = null;
    });
  }

  // Only send once: user's input or quick action, never both
  Future<void> sendPromptToGemini(String prompt) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final response = await http.post(
        Uri.parse(_geminiEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': _geminiApiKey,
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String aiResponse = jsonResponse['candidates'][0]['content']['parts'][0]['text'] as String;
        setState(() {
          messages.add({'sender': 'AI', 'text': aiResponse.trim(), 'time': _getCurrentTime()});
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'API error: ${response.statusCode}\n${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Exception: $e';
        isLoading = false;
      });
    }
  }

  void handleStudyOption(String option) async {
    String userInput = _messageController.text.trim();
    String prompt = "";
    if (attachedFile != null) {
      prompt = "$option the content of this file named ${attachedFile!['name']} with extension ${attachedFile!['extension']}.";
      String? attachedText;
      if (attachedFile!['extension'] == 'pdf') {
        try {
          Uint8List bytes;
          if (kIsWeb) {
            bytes = attachedFile!['bytes'];
          } else {
            final file = File(attachedFile!['path']);
            bytes = await file.readAsBytes();
          }
          PdfDocument document = PdfDocument(inputBytes: bytes);
          attachedText = PdfTextExtractor(document).extractText();
          document.dispose();
          prompt += " File content: $attachedText";
        } catch (e) {
          setState(() { errorMessage = 'Failed to extract PDF text: $e'; });
          return;
        }
      }
      if (userInput.isNotEmpty) {
        prompt += " Additional info: $userInput";
      }
      clearAttachment();
      _messageController.clear();
      setState(() {
        messages.add({'sender': 'User', 'text': "$option${userInput.isNotEmpty ? ": $userInput" : ""}", 'time': _getCurrentTime()});
      });
      await sendPromptToGemini(prompt);
    } else if (userInput.isNotEmpty) {
      prompt = "$option: $userInput";
      _messageController.clear();
      setState(() {
        messages.add({'sender': 'User', 'text': "$option: $userInput", 'time': _getCurrentTime()});
      });
      await sendPromptToGemini(prompt);
    } else {
      prompt = option;
      setState(() {
        messages.add({'sender': 'User', 'text': option, 'time': _getCurrentTime()});
      });
      await sendPromptToGemini(prompt);
    }
    setState(() {
      selectedFeature = null;
    });
  }

  Future<void> handleManualSend() async {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        messages.add({'sender': 'User', 'text': message, 'time': _getCurrentTime()});
        _messageController.clear();
      });
      await sendPromptToGemini(message);
    }
  }

  Widget _studyButton(IconData icon, String label, Color color, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: selected ? color : color.withOpacity(0.75),
              child: Icon(icon, size: 26, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(Map<String, String> message) {
    bool isUser = message['sender'] == 'User';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(13),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.blueAccent.withOpacity(0.26)
              : Colors.white.withOpacity(0.11),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message['text'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.white)),
            const SizedBox(height: 4),
            Text(message['time'] ?? '', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.47), fontWeight: FontWeight.w500)),
          ],
        ),
      ),
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
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryColor.withOpacity(0.8)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.psychology_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Study Assistant',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryTextColor,
                                  ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppTheme.successColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Online',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppTheme.successColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                            Text(
                              'Always here to help you learn',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Feature Buttons Row like Code 1
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: List.generate(_features.length, (index) {
                        var ft = _features[index];
                        return _studyButton(
                          ft['icon'], ft['title'], ft['color'],
                          selectedFeature == ft['title'],
                          () {
                            setState(() { selectedFeature = ft['title']; });
                            handleStudyOption(ft['title']);
                          }
                        );
                      }),
                    ),
                  ),
                ),

                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                  ),
                if (isLoading) const LinearProgressIndicator(),

                // Chat history
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    children: messages.map(_buildMessage).toList(),
                  ),
                ),

                // Input Field + Send and Attach
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: "Ask me anything about your studies...",
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 13),
                            ),
                            style: const TextStyle(fontSize: 15, color: Colors.white),
                            onSubmitted: (value) async {
                              await handleManualSend();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      // Attach icon BESIDE Send icon
                      IconButton(
                        icon: const Icon(Icons.send, color: Color(0xffbbafff), size: 26),
                        tooltip: "Send message",
                        onPressed: isLoading ? null : handleManualSend,
                      ),
                      IconButton(
                        icon: const Icon(Icons.attach_file, color: Color(0xffbbafff), size: 26),
                        tooltip: "Attach file",
                        onPressed: isLoading ? null : pickFile,
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
}
