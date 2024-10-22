import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/user_profile_model.dart';

import 'package:hungrx_app/data/repositories/user_info_profile_repository.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_event.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileFormBloc
    extends Bloc<UserProfileFormEvent, UserProfileFormState> {
final UserProfileRepository _userProfileRepository;

  UserProfileFormBloc(
      this._userProfileRepository,)
      : super(const UserProfileFormState()) {
    on<NameChanged>(_onNameChanged);
    on<UnitChanged>(_onUnitChanged);
    on<GenderChanged>(_onGenderChanged);
    on<AgeChanged>(_onAgeChanged);
    on<HeightChanged>(_onHeightChanged);
    on<HeightFeetChanged>(_onHeightFeetChanged);
    on<HeightInchesChanged>(_onHeightInchesChanged);
    on<WeightChanged>(_onWeightChanged);
    on<MealsPerDayChanged>(_onMealsPerDayChanged);
    on<GoalChanged>(_onGoalChanged);
    on<TargetWeightChanged>(_onTargetWeightChanged);
    on<WeightPaceChanged>(_onWeightPaceChanged);
    on<ActivityLevelChanged>(_onActivityLevelChanged);
    on<SubmitForm>(_onSubmitForm);
  }
  void _onUnitChanged(UnitChanged event, Emitter<UserProfileFormState> emit) {
    emit(state.copyWith(isMetric: event.isMetric));
  }

  void _onNameChanged(NameChanged event, Emitter<UserProfileFormState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onGenderChanged(
      GenderChanged event, Emitter<UserProfileFormState> emit) {
    emit(state.copyWith(gender: event.gender));
  }

  void _onAgeChanged(AgeChanged event, Emitter<UserProfileFormState> emit) {
    emit(state.copyWith(age: event.age));
  }

  void _onHeightChanged(
      HeightChanged event, Emitter<UserProfileFormState> emit) {
    emit(state.copyWith(height: event.height));
  }

  void _onHeightFeetChanged(
      HeightFeetChanged event, Emitter<UserProfileFormState> emit) {
    emit(state.copyWith(heightFeet: event.feet));
  }

  void _onHeightInchesChanged(
      HeightInchesChanged event, Emitter<UserProfileFormState> emit) {
    emit(state.copyWith(heightInches: event.inches));
  }

  void _onWeightChanged(
      WeightChanged event, Emitter<UserProfileFormState> emit) {
    emit(state.copyWith(weight: event.weight));
  }

  void _onMealsPerDayChanged(
      MealsPerDayChanged event, Emitter<UserProfileFormState> emit) {
    emit(state.copyWith(mealsPerDay: event.mealsPerDay));
  }

  void _onGoalChanged(GoalChanged event, Emitter<UserProfileFormState> emit) {
    emit(state.copyWith(weightGoal: event.goal));
  }

  void _onTargetWeightChanged(
      TargetWeightChanged event, Emitter<UserProfileFormState> emit) {
    emit(state.copyWith(targetWeight: event.targetWeight));
  }

  void _onWeightPaceChanged(
      WeightPaceChanged event, Emitter<UserProfileFormState> emit) {
    emit(state.copyWith(weightPace: event.pace));
  }

  void _onActivityLevelChanged(
      ActivityLevelChanged event, Emitter<UserProfileFormState> emit) {
    emit(state.copyWith(activityLevel: event.activityLevel));
  }

  Future<void> _onSubmitForm(
      SubmitForm event, Emitter<UserProfileFormState> emit) async {
    emit(state.copyWith(isSubmitting: true));
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? '';

      final userProfile = UserInfoProfileModel(
        userId: userId,
        name: state.name ?? '',
        gender: state.gender?.toLowerCase() ?? '',
        heightInCm: double.tryParse(state.height)??0,
        heightInFeet: double.tryParse(state.heightFeet)??0,
        heightInInches: double.tryParse(state.heightInches)??0,
        isMetric: state.isMetric,
        weight: double.parse(state.weight ?? '0'),
        mealsPerDay: state.mealsPerDay?.round() ?? 3,
        goal: _mapWeightGoalToString(state.weightGoal),
        targetWeight: double.parse(state.targetWeight ?? '0'),
        weightGainRate: _mapweightGainRate(state.weightPace),
        activityLevel: _mapActivityLevelToString(state.activityLevel),
      );

      await _userProfileRepository.addUserProfile(userProfile);
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (error) {
      emit(state.copyWith(isSubmitting: false, errorMessage: error.toString()));
    }
  }

  String _mapWeightGoalToString(WeightGoal? goal) {
    switch (goal) {
      case WeightGoal.lose:
        return 'lose weight';
      case WeightGoal.maintain:
        return 'maintain weight';
      case WeightGoal.gain:
        return 'gain weight';
      default:
        return 'maintain weight';
    }
  }

  double _mapweightGainRate(double? pace) {
    if (pace == 1) return 0.25;
    if (pace == 2) return 0.5;
    if (pace == 3) return 0.75;
    if (pace == 4) return 1;
    return 0.25;
  }

  String _mapActivityLevelToString(ActivityLevel? level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'sedentary';
      case ActivityLevel.lightlyActive:
        return 'lightly active';
      case ActivityLevel.moderatelyActive:
        return 'moderately active';
      case ActivityLevel.veryActive:
        return 'very active';
      case ActivityLevel.extraActive:
        return 'extra active';
      default:
        return 'moderately active';
    }
  }
}

enum WeightGoal { lose, maintain, gain }

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extraActive
}
