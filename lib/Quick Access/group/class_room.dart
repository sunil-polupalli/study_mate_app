import 'package:flutter/material.dart';
import 'package:study_mate_app/Quick%20Access/group/subjectPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class ClassRoom extends StatefulWidget {
  const ClassRoom({super.key});

  @override
  State<ClassRoom> createState() => _ClassRoomState();
}

class _ClassRoomState extends State<ClassRoom> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> joinedGroups = [];

  @override
  void initState() {
    super.initState();
    _fetchAllGroups();
  }

  String generateGroupCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  /// Fetch all groups the user has joined or created
  Future<void> _fetchAllGroups() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      // Groups where user is a member
      final List memberGroups = await supabase
          .from('group_members')
          .select('groups(*)')
          .eq('user_id', user.id);

      // Groups created by the user
      final List createdGroups = await supabase
          .from('groups')
          .select('*')
          .eq('created_by', user.id);

      // Merge and remove duplicates
      final Map<String, Map<String, dynamic>> groupsMap = {};

      for (var e in memberGroups) {
        if (e['groups'] != null) {
          groupsMap[e['groups']['id']] = Map<String, dynamic>.from(e['groups']);
        }
      }

      for (var g in createdGroups) {
        groupsMap[g['id']] = Map<String, dynamic>.from(g);
      }

      setState(() {
        joinedGroups = groupsMap.values.toList();
      });
    } catch (e) {
      print("Error fetching groups: $e");
    }
  }

  /// Show dialog to create a new group
  void _showAddGroupDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Create Group"),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Group Name",
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Enter group name"
                                  : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _createGroup(
                      _nameController.text,
                      _descriptionController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("Create"),
              ),
            ],
          ),
    );
  }

  /// Create a new group with a code and add creator as admin
  Future<void> _createGroup(String name, String description) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final code = generateGroupCode();

      final List groupData =
          await supabase.from('groups').insert({
            'name': name,
            'description': description,
            'created_by': user.id,
            'code': code,
          }).select();

      if (groupData.isEmpty) return;

      final newGroup = Map<String, dynamic>.from(groupData[0]);

      await supabase.from('group_members').insert({
        'group_id': newGroup['id'],
        'user_id': user.id,
        'role': 'admin',
      });

      _fetchAllGroups();
      print("Group created with code: $code");
    } catch (e) {
      print("Error creating/joining group: $e");
    }
  }

  /// Show dialog to join a group by code
  void _showJoinGroupDialog(BuildContext context) {
    final _codeController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Join Group"),
            content: TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: "Enter Group Code"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final code = _codeController.text.trim();
                  if (code.isNotEmpty) {
                    await _joinGroupByCode(code);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Join"),
              ),
            ],
          ),
    );
  }

  /// Join an existing group by code
  Future<void> _joinGroupByCode(String code) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final List groups = await supabase
          .from('groups')
          .select('*')
          .eq('code', code);

      if (groups.isEmpty) {
        print("Invalid group code");
        return;
      }

      final group = Map<String, dynamic>.from(groups[0]);

      // Prevent duplicate membership
      final exists = await supabase
          .from('group_members')
          .select('*')
          .eq('group_id', group['id'])
          .eq('user_id', user.id);

      if (exists.isNotEmpty) {
        print("You are already a member of this group");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You are already a member of this group"),
          ),
        );
        return;
      }

      await supabase.from('group_members').insert({
        'group_id': group['id'],
        'user_id': user.id,
        'role': 'member',
      });

      _fetchAllGroups();
      print("Joined group: ${group['name']}");
    } catch (e) {
      print("Error joining group: $e");
    }
  }

  /// Delete a group (only admin/creator)
  Future<void> _deleteGroup(String groupId) async {
    try {
      await supabase.from('groups').delete().eq('id', groupId);
      _fetchAllGroups();
      print("Group deleted successfully");
    } catch (e) {
      print("Error deleting group: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("ClassRoom"),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: () => _showJoinGroupDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            joinedGroups.isEmpty
                ? const Center(
                  child: Text("You have not joined any groups yet"),
                )
                : RefreshIndicator(
                  onRefresh: _fetchAllGroups,
                  child: ListView.builder(
                    itemCount: joinedGroups.length,
                    itemBuilder: (context, index) {
                      final group = joinedGroups[index];
                      final isAdmin =
                          user != null && group['created_by'] == user.id;

                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => SubjectsPage(groupId: group['id']),
                              ),
                            );
                          },

                          title: Text(group['name'] ?? ''),
                          subtitle: Text(
                            "${group['description'] ?? ''}\nCode: ${group['code'] ?? ''}",
                          ),
                          isThreeLine: true,
                          trailing:
                              isAdmin
                                  ? IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _deleteGroup(group['id']),
                                  )
                                  : null, // only admin can delete
                        ),
                      );
                    },
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGroupDialog(context),
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }
}
