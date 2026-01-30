import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  int age;

  @HiveField(1)
  String gender; // 'male' or 'female'

  @HiveField(2)
  double height; // cm

  @HiveField(3)
  double weight; // kg

  @HiveField(4)
  String goal; // 'lose', 'maintain', 'gain'

  @HiveField(5)
  String activityLevel; // 'sedentary', 'light', 'moderate', 'active'

  UserProfile({
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.goal,
    this.activityLevel = 'sedentary',
  });

  // Mifflin-St Jeor Equation
  int get dailyCalorieTarget {
    double bmr;
    if (gender == 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    double activityMultiplier;
    switch (activityLevel) {
      case 'light':
        activityMultiplier = 1.375;
        break;
      case 'moderate':
        activityMultiplier = 1.55;
        break;
      case 'active':
        activityMultiplier = 1.725;
        break;
      default:
        activityMultiplier = 1.2;
    }

    double tdee = bmr * activityMultiplier;

    if (goal == 'lose') return (tdee - 500).round();
    if (goal == 'gain') return (tdee + 500).round();
    return tdee.round();
  }
}
