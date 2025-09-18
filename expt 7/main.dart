import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Signup Page',
      theme: ThemeData.dark(),
      home: const SignupScreen(),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  bool _isBusiness = false;
  String _maritalStatus = "single";
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D28D9), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Name field
                    TextFormField(
                      decoration: _inputDecoration("Full Name"),
                      style: const TextStyle(color: Colors.white),
                      validator: (val) =>
                          val!.isEmpty ? "Enter your name" : null,
                    ),
                    const SizedBox(height: 20),

                    // Email field
                    TextFormField(
                      decoration: _inputDecoration("Email"),
                      style: const TextStyle(color: Colors.white),
                      validator: (val) =>
                          val!.contains('@') ? null : "Enter valid email",
                    ),
                    const SizedBox(height: 20),

                    // Password field with toggle
                    TextFormField(
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration("Password").copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (val) => val!.length < 8
                          ? "Password must be 8+ chars"
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Account Type (Business / Personal)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Account Type",
                            style: TextStyle(color: Colors.white)),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                value: false,
                                groupValue: _isBusiness,
                                onChanged: (val) {
                                  setState(() => _isBusiness = val!);
                                },
                                title: const Text("Personal",
                                    style: TextStyle(color: Colors.white)),
                                activeColor: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                value: true,
                                groupValue: _isBusiness,
                                onChanged: (val) {
                                  setState(() => _isBusiness = val!);
                                },
                                title: const Text("Business",
                                    style: TextStyle(color: Colors.white)),
                                activeColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Marital Status (Single / Married / Other)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Marital Status",
                            style: TextStyle(color: Colors.white)),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                value: "single",
                                groupValue: _maritalStatus,
                                onChanged: (val) {
                                  setState(() => _maritalStatus = val!);
                                },
                                title: const Text("Single",
                                    style: TextStyle(color: Colors.white)),
                                activeColor: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                value: "married",
                                groupValue: _maritalStatus,
                                onChanged: (val) {
                                  setState(() => _maritalStatus = val!);
                                },
                                title: const Text("Married",
                                    style: TextStyle(color: Colors.white)),
                                activeColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                value: "other",
                                groupValue: _maritalStatus,
                                onChanged: (val) {
                                  setState(() => _maritalStatus = val!);
                                },
                                title: const Text("Other",
                                    style: TextStyle(color: Colors.white)),
                                activeColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Country Dropdown
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.black87,
                      decoration: _inputDecoration("Country"),
                      style: const TextStyle(color: Colors.white),
                      items: ["India", "USA", "UK", "Canada", "Other"]
                          .map((country) => DropdownMenuItem(
                                value: country,
                                child: Text(country,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                      onChanged: (val) {},
                      validator: (val) =>
                          val == null ? "Select a country" : null,
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Creating account...")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Sign Up",
                          style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }
}
