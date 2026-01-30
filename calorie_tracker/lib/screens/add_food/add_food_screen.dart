import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/food_item.dart';
import '../../providers/app_state.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  String _name = '';
  int _calories = 0;
  double _protein = 0;
  double _fat = 0;
  double _carbs = 0;
  bool _addToFavorites = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final food = FoodItem(
        name: _name,
        calories: _calories,
        protein: _protein,
        fat: _fat,
        carbs: _carbs,
        isFavorite: _addToFavorites,
      );
      
      final appState = context.read<AppState>();
      appState.addFood(food);
      if (_addToFavorites) {
        appState.toggleFavorite(food);
      }
      
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'New Entry'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Manual Entry
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Food Name (e.g. Chicken Rice)'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => _name = v!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Calories (kcal)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => _calories = int.tryParse(v ?? '') ?? 0,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Protein (g)'),
                          keyboardType: TextInputType.number,
                          onSaved: (v) => _protein = double.tryParse(v ?? '') ?? 0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Fat (g)'),
                          keyboardType: TextInputType.number,
                          onSaved: (v) => _fat = double.tryParse(v ?? '') ?? 0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Carbs (g)'),
                          keyboardType: TextInputType.number,
                          onSaved: (v) => _carbs = double.tryParse(v ?? '') ?? 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text('Save to Favorites'),
                    value: _addToFavorites,
                    onChanged: (v) => setState(() => _addToFavorites = v!),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check),
                    label: const Text('Add to Diary'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Tab 2: Favorites
          Consumer<AppState>(
            builder: (context, appState, _) {
              final favorites = appState.favoriteFoods;
              if (favorites.isEmpty) {
                return const Center(child: Text('No favorites yet.'));
              }
              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final item = favorites[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('${item.calories} kcal'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        // Clone item and add
                        appState.addFood(FoodItem(
                          name: item.name,
                          calories: item.calories,
                          protein: item.protein,
                          fat: item.fat,
                          carbs: item.carbs,
                          isFavorite: true,
                        ));
                        context.pop();
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
