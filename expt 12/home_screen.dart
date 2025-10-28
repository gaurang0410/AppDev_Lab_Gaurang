import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home (Protected)'),
        actions: [
          // Sign Out Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              // AuthGate will automatically navigate to LoginScreen
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              if (user != null) ...[
                Text(
                  'You are logged in as:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  user.email ?? 'No email',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                 const SizedBox(height: 5),
                 Text(
                  '(User ID: ${user.uid})',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
