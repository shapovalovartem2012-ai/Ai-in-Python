import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';
import '../../providers/app_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  int _age = 25;
  String _gender = 'male';
  double _height = 170;
  double _weight = 70;
  String _goal = 'maintain';
  String _activity = 'sedentary';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Let\'s set up your profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                ],
                onChanged: (v) => setState(() => _gender = v!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _age.toString(),
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _age = int.tryParse(v ?? '') ?? 25,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _height.toString(),
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _height = double.tryParse(v ?? '') ?? 170,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _weight.toString(),
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _weight = double.tryParse(v ?? '') ?? 70,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _activity,
                decoration: const InputDecoration(labelText: 'Activity Level'),
                items: const [
                  DropdownMenuItem(value: 'sedentary', child: Text('Sedentary (Office job)')),
                  DropdownMenuItem(value: 'light', child: Text('Light Exercise')),
                  DropdownMenuItem(value: 'moderate', child: Text('Moderate Exercise')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                ],
                onChanged: (v) => setState(() => _activity = v!),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _goal,
                decoration: const InputDecoration(labelText: 'Goal'),
                items: const [
                  DropdownMenuItem(value: 'lose', child: Text('Lose Weight')),
                  DropdownMenuItem(value: 'maintain', child: Text('Maintain Weight')),
                  DropdownMenuItem(value: 'gain', child: Text('Gain Muscle')),
                ],
                onChanged: (v) => setState(() => _goal = v!),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    
                    final profile = UserProfile(
                      age: _age,
                      gender: _gender,
                      height: _height,
                      weight: _weight,
                      goal: _goal,
                      activityLevel: _activity,
                    );
                    
                    context.read<AppState>().saveProfile(profile);
                    // Router redirect will handle navigation to /home
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Start Tracking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
