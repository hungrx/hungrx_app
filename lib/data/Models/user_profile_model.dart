import 'package:equatable/equatable.dart';

class UserInfoProfileModel extends Equatable {
  final String userId;
  final String name;
  final String gender;
  final double heightInCm;
  final double heightInFeet;
  final double heightInInches;
  final bool isMetric;
  final double weightInKg;
  final double weightInLbs;
  final int mealsPerDay;
  final String goal;
  final double targetWeight;
  final double weightGainRate;
  final String activityLevel;
  final int age;

  const UserInfoProfileModel({
    required this.weightInLbs,
    required this.age,
    required this.userId,
    required this.name,
    required this.gender,
    required this.heightInCm,
    required this.heightInFeet,
    required this.heightInInches,
    required this.isMetric,
    required this.weightInKg,
    required this.mealsPerDay,
    required this.goal,
    required this.targetWeight,
    required this.weightGainRate,
    required this.activityLevel,
  });

  Map<String, dynamic> toJson() => {
        'age': age,
        'userId': userId,
        'name': name,
        'gender': gender,
        'heightInCm': heightInCm,
        'heightInFeet': heightInFeet,
        'heightInInches': heightInInches,
        'isMetric': isMetric,
        'weightInKg': weightInKg,
        'weightInLbs':weightInLbs,
        'mealsPerDay': mealsPerDay,
        'goal': goal,
        'targetWeight': targetWeight,
        'weightGainRate': weightGainRate,
        'activityLevel': activityLevel,
      };

  @override
  List<Object?> get props => [
        age,
        userId,
        name,
        gender,
        heightInCm,
        heightInFeet,
        heightInInches,
        weightInLbs,
        isMetric,
        weightInKg,
        mealsPerDay,
        goal,
        targetWeight,
        weightGainRate,
        activityLevel,
      ];
}
