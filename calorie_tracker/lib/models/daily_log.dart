import 'package:hive/hive.dart';
import 'food_item.dart';

part 'daily_log.g.dart';

@HiveType(typeId: 2)
class DailyLog extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  List<FoodItem> items;

  DailyLog({
    required this.date,
    required this.items,
  });

  int get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
  double get totalProtein => items.fold(0, (sum, item) => sum + item.protein);
  double get totalFat => items.fold(0, (sum, item) => sum + item.fat);
  double get totalCarbs => items.fold(0, (sum, item) => sum + item.carbs);
}
