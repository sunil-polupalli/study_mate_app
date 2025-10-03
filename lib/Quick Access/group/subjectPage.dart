import 'package:flutter/material.dart';
import 'package:study_mate_app/Quick%20Access/group/pdfPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubjectsPage extends StatefulWidget {
  final String groupId;
  const SubjectsPage({super.key, required this.groupId});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> subjects = [];

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    final data = await supabase
        .from('subjects')
        .select('*')
        .eq('group_id', widget.groupId)
        .order('created_at');
    setState(() {
      subjects = List<Map<String, dynamic>>.from(data);
    });
  }

  void _showAddSubjectDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Subject"),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: "Subject Name")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await supabase.from('subjects').insert({
                  'name': controller.text,
                  'group_id': widget.groupId,
                });
                Navigator.pop(context);
                _fetchSubjects();
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subjects")),
      body: subjects.isEmpty
          ? const Center(child: Text("No subjects yet"))
          : ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (_, i) {
                final subject = subjects[i];
                return ListTile(
                  title: Text(subject['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PdfPage(subjectId: subject['id'], subjectName: subject['name'])),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSubjectDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
