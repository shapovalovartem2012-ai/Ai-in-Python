import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final profile = appState.userProfile;

    if (profile == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 16),
            Text('Daily Target: ${profile.dailyCalorieTarget} kcal',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 32),
            
            ListTile(
              leading: const Icon(Icons.straighten),
              title: const Text('Height'),
              trailing: Text('${profile.height} cm'),
            ),
            ListTile(
              leading: const Icon(Icons.monitor_weight),
              title: const Text('Weight'),
              trailing: Text('${profile.weight} kg'),
            ),
             ListTile(
              leading: const Icon(Icons.cake),
              title: const Text('Age'),
              trailing: Text('${profile.age} years'),
            ),
             ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Goal'),
              trailing: Text(profile.goal.toUpperCase()),
            ),
            
            const Divider(height: 32),
            
            // PRO Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade300, Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text('Upgrade to PRO', 
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Get extended analytics, history, and personal recommendations.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment flow placeholder'))
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepOrange,
                    ),
                    child: const Text('Get PRO'),
                  ),
                ],
              ),
            ),
            
             const SizedBox(height: 32),
             TextButton(
               onPressed: () {
                 // Logout logic would go here (clear hive box or just reset)
                 // For now, just re-onboard?
                 context.go('/onboarding');
               },
               child: const Text('Edit Profile / Reset'),
             ),
          ],
        ),
      ),
    );
  }
}
