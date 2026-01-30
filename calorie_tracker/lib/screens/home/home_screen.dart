import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final profile = appState.userProfile;
    final log = appState.todayLog;

    if (profile == null || log == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final target = profile.dailyCalorieTarget;
    final eaten = log.totalCalories;
    final remaining = target - eaten;
    final progress = (eaten / target).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('Calories Remaining', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey[200],
                            color: remaining < 0 ? Colors.red : Theme.of(context).primaryColor,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              remaining.toString(),
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            const Text('kcal'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MacroItem(label: 'Eaten', value: '$eaten'),
                        _MacroItem(label: 'Target', value: '$target'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Food List
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Meals', style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(height: 8),
            
            if (log.items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No food added yet.', style: TextStyle(color: Colors.grey)),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: log.items.length,
                itemBuilder: (context, index) {
                  final item = log.items[index];
                  return ListTile(
                    leading: const Icon(Icons.fastfood), // Placeholder icon
                    title: Text(item.name),
                    subtitle: Text('${item.protein}p • ${item.fat}f • ${item.carbs}c'),
                    trailing: Text('${item.calories} kcal'),
                    onLongPress: () {
                      // Simple delete confirm
                      showDialog(
                        context: context, 
                        builder: (_) => AlertDialog(
                          title: const Text('Delete?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
                            TextButton(onPressed: () {
                               appState.removeFood(index);
                               Navigator.pop(context);
                            }, child: const Text('Yes')),
                          ],
                        )
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-food'),
        label: const Text('Add Food'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;
  const _MacroItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
