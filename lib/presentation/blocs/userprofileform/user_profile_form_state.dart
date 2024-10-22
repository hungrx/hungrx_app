import 'package:equatable/equatable.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';


class UserProfileFormState extends Equatable {
  final String? name;
  final String? gender;
  final String? age;
  final String height;
  final String heightFeet;
  final String heightInches;
  final String? weight;
  final double? mealsPerDay;
  final WeightGoal? weightGoal;
  final String? targetWeight;
  final double? weightPace;
  final ActivityLevel? activityLevel;
  final bool isMetric;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const UserProfileFormState({
    this.name,
    this.gender,
    this.age,
    this.height = '',
    this.heightFeet = '',
    this.heightInches = '',
    this.weight,
    this.mealsPerDay,
    this.weightGoal,
    this.targetWeight,
    this.weightPace,
    this.activityLevel,
    this.isMetric = true,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  UserProfileFormState copyWith({
    String? name,
    String? gender,
    String? age,
    String? height,
    String? heightFeet,
    String? heightInches,
    String? weight,
    double? mealsPerDay,
    WeightGoal? weightGoal,
    String? targetWeight,
    double? weightPace,
    ActivityLevel? activityLevel,
    bool? isMetric,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return UserProfileFormState(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      heightFeet: heightFeet ?? this.heightFeet,
      heightInches: heightInches ?? this.heightInches,
      weight: weight ?? this.weight,
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
      weightGoal: weightGoal ?? this.weightGoal,
      targetWeight: targetWeight ?? this.targetWeight,
      weightPace: weightPace ?? this.weightPace,
      activityLevel: activityLevel ?? this.activityLevel,
      isMetric: isMetric ?? this.isMetric,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        name,
        gender,
        age,
        height,
        heightFeet,
        heightInches,
        weight,
        mealsPerDay,
        weightGoal,
        targetWeight,
        weightPace,
        activityLevel,
        isMetric,
        isSubmitting,
        isSuccess,
        errorMessage
      ];
}
