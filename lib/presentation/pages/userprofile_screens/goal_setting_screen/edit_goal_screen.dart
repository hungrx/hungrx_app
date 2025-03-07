import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/data/Models/profile_screen/update_goal_settings_model.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/update_goal_settings_api.dart';
import 'package:hungrx_app/data/repositories/profile_setting_screen/update_goal_settings_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/update_goal_settings_usecase.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_event.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_bloc.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_event.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/timezone/timezone_bloc.dart';
import 'package:hungrx_app/presentation/blocs/timezone/timezone_event.dart';
import 'package:hungrx_app/presentation/blocs/update_goal_settings/update_goal_settings_bloc.dart';
import 'package:hungrx_app/presentation/blocs/update_goal_settings/update_goal_settings_event.dart';
import 'package:hungrx_app/presentation/blocs/update_goal_settings/update_goal_settings_state.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_bloc.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_event.dart';
import 'package:hungrx_app/routes/route_names.dart';

class GoalSettingsEditScreen extends StatefulWidget {
  final String goal;
  final String targetWeight;
  final double weightGainRate;
  final String activityLevel;
  final int mealsPerDay;
  final bool isMetric;
  final double currentWeight;
  final bool isMaintain;

  const GoalSettingsEditScreen({
    super.key,
    required this.goal,
    required this.targetWeight,
    required this.isMetric,
    required this.currentWeight,
    required this.weightGainRate,
    required this.activityLevel,
    required this.mealsPerDay,
    required this.isMaintain,
  });

  @override
  State<GoalSettingsEditScreen> createState() => _GoalSettingsEditScreenState();
}

class _GoalSettingsEditScreenState extends State<GoalSettingsEditScreen> {
  late String _goal;
  late String _targetWeight;
  late double _weightGainRate;
  late String _activityLevel;
  late int _mealsPerDay;
  late UpdateGoalSettingsBloc _bloc;
  final AuthService _authService = AuthService();
  String? _userId;

  @override
  void initState() {
    super.initState();
    _goal = widget.goal;
    _targetWeight = widget.targetWeight;
    _weightGainRate = widget.weightGainRate;
    _activityLevel = widget.activityLevel;
    _mealsPerDay = widget.mealsPerDay;
    _bloc = UpdateGoalSettingsBloc(
      useCase: UpdateGoalSettingsUseCase(
        repository: UpdateGoalSettingsRepository(
          api: UpdateGoalSettingsApi(),
        ),
      ),
    );
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {

    final userId = await _authService.getUserId();
    _updateUserTimezone(userId??"");
    setState(() {
      _userId = userId;
    });
  }

    Future<void> _updateUserTimezone(String userId) async {
    
    context.read<TimezoneBloc>().add(UpdateUserTimezone(userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener<UpdateGoalSettingsBloc, UpdateGoalSettingsState>(
        listener: (context, state) {
          if (state is UpdateGoalSettingsSuccess) {
            context.read<GetProfileDetailsBloc>().add(FetchProfileDetails());
            context.read<GoalSettingsBloc>().add(FetchGoalSettings());
            context.read<EatScreenBloc>().add(GetEatScreenDataEvent());
            context.read<HomeBloc>().add(RefreshHomeData());
            if (widget.isMaintain) {
              context.read<WeightUpdateBloc>().add(
                    UpdateWeightRequested(widget.currentWeight),
                  );
              context.read<HomeBloc>().add(RefreshHomeData());
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Goal settings updated successfully')),
            );
            context.goNamed(RouteNames.home);
            // Navigator.pop(context, state.settings);
          } else if (state is UpdateGoalSettingsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    _buildWeightGoalSection(),
                    const SizedBox(height: 32),
                    if (_goal != 'maintain weight') ...[
                      _buildTargetWeightSection(),
                      const SizedBox(height: 32),
                    ],
                    _buildWeightGainRateSection(),
                    const SizedBox(height: 32),
                    _buildActivityLevelSection(),
                    const SizedBox(height: 32),
                    _buildMealsPerDaySection(),
                    const SizedBox(height: 40),
                    _buildSaveButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        const SizedBox(width: 16),
        const Text(
          'Edit Goal Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildWeightGoalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is your goal?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildGoalButton('Lose Weight', _goal == 'lose weight'),
        const SizedBox(height: 8),
        _buildGoalButton('Maintain Weight', _goal == 'maintain weight'),
        const SizedBox(height: 8),
        _buildGoalButton('Gain Weight', _goal == 'gain weight'),
      ],
    );
  }

  Widget _buildGoalButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _goal = text.toLowerCase();
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFBBD66F) : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTargetWeightSection() {
    // Function to validate target weight
    String? getTargetWeightError() {
      if (_targetWeight.isEmpty) {
        return 'Target weight is required';
      }

      double? targetWeightNum = double.tryParse(_targetWeight);
      if (targetWeightNum == null) {
        return 'Please enter a valid number';
      }

      if (_goal == 'lose weight' && targetWeightNum >= widget.currentWeight) {
        return 'Target weight must be less than current weight';
      }

      if (_goal == 'gain weight' && targetWeightNum <= widget.currentWeight) {
        return 'Target weight must be greater than current weight';
      }

      return null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Weight (${widget.isMetric ? 'kg' : 'lbs'})',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: _targetWeight,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              _targetWeight = value;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixText: widget.isMetric ? 'kg' : 'lbs',
            suffixStyle: const TextStyle(color: Colors.grey),
            errorText: getTargetWeightError(),
            errorStyle: const TextStyle(color: Colors.red),
            // Add helper text to show current weight
            helperText:
                'Current weight: ${widget.currentWeight} ${widget.isMetric ? 'kg' : 'lbs'}',
            helperStyle: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightGainRateSection() {
    // Helper function to convert kg to lbs
    double kgToLbs(double kg) {
      return kg * 2.20462;
    }

    // Helper function to format weight gain rate with proper unit
    String formatWeightGainRate(double rate, bool isMetric) {
      if (isMetric) {
        return '${rate.toStringAsFixed(2)} kg/week';
      } else {
        double lbs = kgToLbs(rate);
        return '${lbs.toStringAsFixed(2)} lbs/week';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Goal Pace',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Slider(
          value: _weightGainRate,
          min: 0.25,
          max: 0.75,
          divisions: 2,
          activeColor: const Color(0xFFBBD66F),
          inactiveColor: Colors.grey[800],
          label: formatWeightGainRate(_weightGainRate, widget.isMetric),
          onChanged: (value) {
            setState(() {
              _weightGainRate = value;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Mild', 'Moderate', 'Fast']
                .map((e) => Text(
                      e,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity Level',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _activityLevel,
              isExpanded: true,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              items: {
                'sedentary': 'Little to no exercise',
                'lightly active': 'Light exercise 1-3 days/week',
                'moderately active': 'Moderate exercise 3-5 days/week',
                'very active': 'Hard exercise 6-7 days/week',
                'extra active': 'Very hard exercise & physical job',
              }.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text(
                    '${entry.key[0].toUpperCase()}${entry.key.substring(1)} - ${entry.value}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _activityLevel = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealsPerDaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meals Per Day',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Slider(
          value: _mealsPerDay.toDouble(),
          min: 1,
          max: 4,
          divisions: 3,
          activeColor: const Color(0xFFBBD66F),
          inactiveColor: Colors.grey[800],
          label: _mealsPerDay.toString(),
          onChanged: (value) {
            setState(() {
              _mealsPerDay = value.round();
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [1, 2, 3, 4]
                .map((e) => Text(
                      e.toString(),
                      style: const TextStyle(color: Colors.grey),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return BlocBuilder<UpdateGoalSettingsBloc, UpdateGoalSettingsState>(
      builder: (context, state) {
        // Function to check if form is valid
        bool isFormValid() {
          if (_goal == 'maintain weight') return true;

          double? targetWeightNum = double.tryParse(_targetWeight);
          if (targetWeightNum == null) return false;

          if (_goal == 'lose weight' &&
              targetWeightNum >= widget.currentWeight) {
            return false;
          }

          if (_goal == 'gain weight' &&
              targetWeightNum <= widget.currentWeight) {
            return false;
          }

          return true;
        }

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (state is UpdateGoalSettingsLoading || !isFormValid())
                ? null
                : () {
                    final settings = UpdateGoalSettingsModel(
                      userId: _userId ?? "",
                      goal: _goal,
                      targetWeight: _goal == 'maintain weight'
                          ? widget.currentWeight.toString()
                          : _targetWeight,
                      weightGainRate: _weightGainRate,
                      activityLevel: _activityLevel,
                      mealsPerDay: _mealsPerDay,
                    );
                    context.read<UpdateGoalSettingsBloc>().add(
                          UpdateGoalSettingsSubmitted(settings: settings),
                        );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBBD66F),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              // Disable button style
              disabledBackgroundColor: Colors.grey,
              disabledForegroundColor: Colors.white54,
            ),
            child: state is UpdateGoalSettingsLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                : const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
