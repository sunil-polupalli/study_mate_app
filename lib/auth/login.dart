import 'package:flutter/material.dart';
import 'package:study_mate_app/auth/signup.dart';
import 'package:study_mate_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  bool isVis = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  final supabase = Supabase.instance.client;
  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await supabase.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      if (response.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Welcome To StudyMate, Enjoy Your Learning")),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Same dark background as homepage
      backgroundColor: Color(0xFF1a1a2e),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Top spacing and StudyMate title
              SizedBox(height: 40),
              Text(
                "StudyMate",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Login Card - styled exactly like homepage cards
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Color(0xFF2d2d44), // Similar to homepage card colors
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Login icon and title like homepage cards
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFF6B35),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.login,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 30),
                                
                                // Email field
                                Text(
                                  "Email",
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
                                    controller: _emailCtrl,
                                    cursorColor: Color(0xFFFF6B35),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email is required';
                                      } else if (!RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      ).hasMatch(value)) {
                                        return 'Enter a valid email address';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter Email",
                                      hintStyle: TextStyle(color: Colors.white54, fontSize: 16),
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: Colors.white70,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                                    ),
                                  ),
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Password field
                                Text(
                                  "Password",
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
                                    controller: _passCtrl,
                                    cursorColor: Color(0xFFFF6B35),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password is required';
                                      } else if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                    obscureText: !isVis,
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter Password",
                                      hintStyle: TextStyle(color: Colors.white54, fontSize: 16),
                                      prefixIcon: Icon(
                                        Icons.lock_outlined,
                                        color: Colors.white70,
                                      ),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(right: 12.0),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isVis = !isVis;
                                            });
                                          },
                                          icon: Icon(
                                            isVis ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                                    ),
                                  ),
                                ),
                                
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                    onPressed: () {
                                      // Forgot password functionality
                                    },
                                    child: Text(
                                      "Forget Password",
                                      style: TextStyle(
                                        color: Color(0xFFFF6B35),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                SizedBox(height: 10),
                                
                                // Login Button - styled like homepage orange card
                                Container(
                                  width: double.infinity,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF6B35),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFFF6B35).withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
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
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _signIn();
                                      }
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 30),
                        
                        // Sign up prompt
                        Text(
                          "Don't have an Account",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Signup(),
                              ),
                            );
                          },
                          child: Text(
                            "Signup",
                            style: TextStyle(
                              color: Color(0xFFFF6B35),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
