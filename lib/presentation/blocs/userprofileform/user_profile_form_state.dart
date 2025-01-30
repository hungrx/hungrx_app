import 'package:equatable/equatable.dart';
import 'package:hungrx_app/data/Models/profile_setting_screen/tdee_result_model.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';

class UserProfileFormState extends Equatable {
  final TDEEResultModel? tdeeResult;
  final String? name;
  final String? gender;
  final String? age;
  final String heightInCm;
  final String heightFeet;
  final String heightInches;
  final String weight;
  final double? mealsPerDay;
  final WeightGoal? weightGoal;
  final String? targetWeight;
  final double? weightPace;
  final ActivityLevel? activityLevel;
  final bool isMetric;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final bool isLoading;

  const UserProfileFormState({
    this.isLoading = false,
    this.tdeeResult,
    this.name,
    this.gender,
    this.age,
    this.heightInCm = '',
    this.heightFeet = '',
    this.heightInches = '',
    this.weight='',
    this.mealsPerDay,
    this.weightGoal,
    this.targetWeight,
    this.weightPace,
    this.activityLevel,
    this.isMetric = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  UserProfileFormState copyWith({
    TDEEResultModel? tdeeResult,
    bool? isLoading,
    String? name,
    String? gender,
    String? age,
    String? heightInCm,
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
      isLoading: isLoading ?? this.isLoading,
      tdeeResult: tdeeResult ?? this.tdeeResult,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightInCm: heightInCm ?? this.heightInCm,
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
        isLoading,
        name,
        gender,
        age,
        heightInCm,
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
        errorMessage,
        tdeeResult
      ];
}
