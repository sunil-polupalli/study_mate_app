import 'package:flutter/material.dart';
import 'package:study_mate_app/auth/login.dart';
import 'package:study_mate_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
      } else if (event == AuthChangeEvent.signedOut) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Login()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = supabase.auth.currentSession;
    return session == null ? Login() : MainScreen();
  }
}
