import 'package:hive/hive.dart';

part 'food_item.g.dart';

@HiveType(typeId: 1)
class FoodItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int calories;

  @HiveField(2)
  double protein;

  @HiveField(3)
  double fat;

  @HiveField(4)
  double carbs;

  @HiveField(5)
  bool isFavorite;

  FoodItem({
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.isFavorite = false,
  });
}
