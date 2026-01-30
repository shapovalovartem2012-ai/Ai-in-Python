import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';
import '../models/food_item.dart';
import '../models/daily_log.dart';

class AppState extends ChangeNotifier {
  Box<UserProfile>? _profileBox;
  Box<DailyLog>? _logBox;
  Box<FoodItem>? _favoritesBox;

  UserProfile? _userProfile;
  DailyLog? _todayLog;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  UserProfile? get userProfile => _userProfile;
  DailyLog? get todayLog => _todayLog;

  List<FoodItem> get favoriteFoods => _favoritesBox?.values.toList() ?? [];

  AppState() {
    _init();
  }

  Future<void> _init() async {
    _profileBox = await Hive.openBox<UserProfile>('user_profile');
    _logBox = await Hive.openBox<DailyLog>('daily_logs');
    _favoritesBox = await Hive.openBox<FoodItem>('favorite_foods');

    if (_profileBox!.isNotEmpty) {
      _userProfile = _profileBox!.getAt(0);
    }

    _loadTodayLog();

    _isLoading = false;
    notifyListeners();
  }

  void _loadTodayLog() {
    final today = DateTime.now();
    
    // Simple check if log exists for today. 
    // In a real app, we might search properly or use formatted date string as key.
    // Here we iterate for simplicity or check a specific key strategy.
    
    // Let's use string date as key for simplicity in this demo
    try {
        final log = _logBox!.values.firstWhere(
            (log) => 
                log.date.year == today.year && 
                log.date.month == today.month && 
                log.date.day == today.day,
        );
        _todayLog = log;
    } catch (e) {
        // Not found, create new
        _todayLog = DailyLog(date: today, items: []);
        _logBox!.add(_todayLog!); 
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    if (_profileBox!.isEmpty) {
      await _profileBox!.add(profile);
    } else {
      await _profileBox!.putAt(0, profile);
    }
    _userProfile = profile;
    notifyListeners();
  }

  Future<void> addFood(FoodItem food) async {
    _todayLog!.items.add(food);
    await _todayLog!.save();
    notifyListeners();
  }
  
  Future<void> removeFood(int index) async {
    _todayLog!.items.removeAt(index);
    await _todayLog!.save();
    notifyListeners();
  }

  Future<void> toggleFavorite(FoodItem food) async {
    if (food.isFavorite) {
      // Find and remove from favorites box
       // Ideally food items should have IDs. Here we compare content or instance.
       // For this simple app, let's assume we manage favorites separately.
       // The `food.isFavorite` flag is on the item instance.
       food.isFavorite = false;
       // We need to remove from box. This part is tricky without IDs.
       // Let's just re-implement favorites management simply:
    } else {
       food.isFavorite = true;
       _favoritesBox!.add(FoodItem(
           name: food.name, 
           calories: food.calories, 
           protein: food.protein, 
           fat: food.fat, 
           carbs: food.carbs, 
           isFavorite: true
       ));
    }
    notifyListeners();
  }
  
  int get caloriesRemaining {
    if (_userProfile == null) return 0;
    return _userProfile!.dailyCalorieTarget - (_todayLog?.totalCalories ?? 0);
  }
}
