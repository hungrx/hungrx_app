import 'package:equatable/equatable.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';


// Events
abstract class UserProfileFormEvent extends Equatable {
  const UserProfileFormEvent();

  @override
  List<Object?> get props => [];
}

class UnitChanged extends UserProfileFormEvent {
  final bool isMetric;
  const UnitChanged(this.isMetric);
}

class NameChanged extends UserProfileFormEvent {
  final String name;
  const NameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class GenderChanged extends UserProfileFormEvent {
  final String gender;
  const GenderChanged(this.gender);

  @override
  List<Object> get props => [gender];
}

class AgeChanged extends UserProfileFormEvent {
  final String age;
  const AgeChanged(this.age);

  @override
  List<Object> get props => [age];
}

class HeightChanged extends UserProfileFormEvent {
  final String height;
  const HeightChanged(this.height);
}

class HeightFeetChanged extends UserProfileFormEvent {
  final String feet;
  const HeightFeetChanged(this.feet);
}

class HeightInchesChanged extends UserProfileFormEvent {
  final String inches;
  const HeightInchesChanged(this.inches);
}

class WeightChanged extends UserProfileFormEvent {
  final String weight;
  const WeightChanged(this.weight);

  @override
  List<Object> get props => [weight];
}

class MealsPerDayChanged extends UserProfileFormEvent {
  final double mealsPerDay;
  const MealsPerDayChanged(this.mealsPerDay);

  @override
  List<Object> get props => [mealsPerDay];
}

class GoalChanged extends UserProfileFormEvent {
  final WeightGoal goal;
  const GoalChanged(this.goal);

  @override
  List<Object> get props => [goal];
}

class TargetWeightChanged extends UserProfileFormEvent {
  final String targetWeight;
  const TargetWeightChanged(this.targetWeight);

  @override
  List<Object> get props => [targetWeight];
}

class WeightPaceChanged extends UserProfileFormEvent {
  final double pace;
  const WeightPaceChanged(this.pace);

  @override
  List<Object> get props => [pace];
}

class ActivityLevelChanged extends UserProfileFormEvent {
  final ActivityLevel activityLevel;
  const ActivityLevelChanged(this.activityLevel);

  @override
  List<Object> get props => [activityLevel];
}

class SubmitForm extends UserProfileFormEvent {}

class ClearFormData extends UserProfileFormEvent {
  @override
  List<Object?> get props => [];
}
