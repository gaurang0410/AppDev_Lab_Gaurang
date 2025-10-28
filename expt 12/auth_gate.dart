import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart'; // We will create this
import 'home_screen.dart';  // We will create this

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Listen to the authentication state changes
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        // 1. While connecting, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // 2. If the snapshot has data (user is logged in)
        if (snapshot.hasData) {
          // Show the protected Home Screen
          return const HomeScreen();
        }

        // 3. If the snapshot has no data (user is logged out)
        // Show the Login Screen
        return const LoginScreen();
      },
    );
  }
}
