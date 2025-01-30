import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_bloc.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_state.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_bloc.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_event.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_bloc.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_event.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_state.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/goal_setting_screen/edit_goal_screen.dart';
import 'package:hungrx_app/presentation/pages/weight_tracking_screen/widget/celebration_dialog.dart';
import 'package:hungrx_app/presentation/pages/weight_tracking_screen/widget/goal_change_dialog.dart';

class WeightPickerScreen extends StatefulWidget {
  final double currentWeight;
  final bool isMaintain;
  const WeightPickerScreen(
      {super.key, required this.isMaintain, required this.currentWeight});

  @override
  WeightPickerScreenState createState() => WeightPickerScreenState();
}

class WeightPickerScreenState extends State<WeightPickerScreen>
    with TickerProviderStateMixin {
  String selectedValue = ''; // Default weight
  final TextEditingController _weightController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _dialogAnimationController;
  late ConfettiController _confettiController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _setupControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final goalState = context.read<GoalSettingsBloc>().state;
      if (goalState is GoalSettingsLoaded) {
        final currentWeight = goalState.settings.currentWeight;
        setState(() {
          selectedValue = widget.currentWeight == 0.0
              ? currentWeight.toString()
              : widget.currentWeight.toString();
          _weightController.text = widget.currentWeight == 0.0
              ? currentWeight.toString()
              : widget.currentWeight.toString();
        });
      }
    });
  }

  void _setupControllers() {
    _dialogAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _validateAndUpdateWeight();
      }
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _dialogAnimationController.dispose();
    _confettiController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildCurrentWeightDisplay() {
    return BlocBuilder<GoalSettingsBloc, GoalSettingsState>(
      builder: (context, state) {
        if (state is GoalSettingsLoaded) {
          final isMetric = state.settings.isMetric;

          final unit = isMetric ? 'kg' : 'lbs';

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Current Weight',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.currentWeight} $unit',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void showCelebrationDialog(BuildContext context, String currentWeight) {
    CelebrationDialog.show(
      context,
      currentWeight: currentWeight,
      onDialogClosed: (context, setNewGoal) {
        if (setNewGoal) {
          final goalSettingsState = context.read<GoalSettingsBloc>().state;
          if (goalSettingsState is GoalSettingsLoaded) {
            // Update the current weight in goal settings
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GoalSettingsEditScreen(
                  goal:
                      'maintain weight', // Default to maintain weight for new goal
                  targetWeight: goalSettingsState.settings.targetWeight,
                  weightGainRate: goalSettingsState.settings.weightGainRate,
                  activityLevel: goalSettingsState.settings.activityLevel,
                  mealsPerDay: goalSettingsState.settings.mealsPerDay,
                  isMetric: goalSettingsState.settings.isMetric,
                  currentWeight: double.parse(currentWeight),
                  isMaintain: widget.isMaintain,
                ),
              ),
            );
          }
        } else {
          // If user chooses not to set new goal, just close the dialog
          Navigator.of(context).pop(true);
        }
      },
    );
  }

  Future<void> _showGoalChangeDialog(
      BuildContext context, bool isGaining) async {
    await GoalChangeDialog.show(
      context,
      isGaining: isGaining,
      newWeight: double.parse(selectedValue),
      onGoalChangePressed: () => _navigateToGoalSettings(context, isGaining),
    );
  }

  bool _isSignificantWeightChange(double newWeight, double currentWeight) {
    final goalSettingsState = context.read<GoalSettingsBloc>().state;
    if (goalSettingsState is GoalSettingsLoaded) {
      final isMetric = goalSettingsState.settings.isMetric;

      // Convert threshold based on units
      double baseThreshold;
      if (isMetric) {
        // For kg: 1kg threshold for weights under 50kg, 2% for weights above
        baseThreshold = currentWeight < 50 ? 1.0 : currentWeight * 0.02;
      } else {
        // For lbs: 2.2lbs threshold for weights under 110lbs, 2% for weights above
        baseThreshold = currentWeight < 110 ? 2.2 : currentWeight * 0.02;
      }

      double weightDifference = newWeight - currentWeight;
      return weightDifference.abs() >= baseThreshold;
    }
    return false;
  }

  void _validateAndUpdateWeight() {
    if (_weightController.text.isNotEmpty) {
      final goalSettingsState = context.read<GoalSettingsBloc>().state;
      if (goalSettingsState is GoalSettingsLoaded) {
        final isMetric = goalSettingsState.settings.isMetric;
        double? newWeight = double.tryParse(_weightController.text);

        // Set min/max based on units
        final minWeight = isMetric ? 15.0 : 33.0; // 15 kg or 33 lbs
        final maxWeight = isMetric ? 300.0 : 660.0; // 300 kg or 660 lbs

        if (newWeight != null &&
            newWeight >= minWeight &&
            newWeight <= maxWeight) {
          setState(() {
            selectedValue = newWeight.toString();
          });
        } else {
          _weightController.text = selectedValue;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isMetric
                  ? 'Please enter a weight between 15 and 300 kg'
                  : 'Please enter a weight between 33 and 660 lbs'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _navigateToGoalSettings(BuildContext context, bool isGaining) {
    final goalSettingsState = context.read<GoalSettingsBloc>().state;
    if (goalSettingsState is GoalSettingsLoaded) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoalSettingsEditScreen(
            isMaintain: widget.isMaintain,
            goal: isGaining ? 'lose weight' : 'gain weight',
            targetWeight: goalSettingsState.settings.targetWeight,
            weightGainRate: goalSettingsState.settings.weightGainRate,
            activityLevel: goalSettingsState.settings.activityLevel,
            mealsPerDay: goalSettingsState.settings.mealsPerDay,
            isMetric: goalSettingsState.settings.isMetric,
            currentWeight: double.parse(selectedValue),
          ),
        ),
      );
    }
  }

  void _handleWeightSubmission(BuildContext context, WeightUpdateState state) {
    if (selectedValue.isEmpty) return;

    double newWeight = double.parse(selectedValue);
    final goalSettingsState = context.read<GoalSettingsBloc>().state;

    if (goalSettingsState is GoalSettingsLoaded) {
      double targetWeight =
          double.tryParse(goalSettingsState.settings.targetWeight) ?? 0.0;
      if (targetWeight == 0.0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid target weight value'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Check if target weight is reached or crossed
      bool isGoalAchieved = false;
      if (goalSettingsState.settings.goal.toLowerCase().contains('lose')) {
        // For weight loss goals, check if weight is less than or equal to target
        isGoalAchieved = newWeight <= targetWeight;
      } else if (goalSettingsState.settings.goal
          .toLowerCase()
          .contains('gain')) {
        // For weight gain goals, check if weight is greater than or equal to target
        isGoalAchieved = newWeight >= targetWeight;
      }

      if (isGoalAchieved) {
        _confettiController.play();
        _dialogAnimationController.forward();

        // First update the weight
        context.read<WeightUpdateBloc>().add(
              UpdateWeightRequested(newWeight),
            );

        // Then show celebration dialog
        showCelebrationDialog(context, selectedValue);
        return;
      }

      // Handle maintain mode specific logic
      if (widget.isMaintain) {
        double currentWeight = goalSettingsState.settings.currentWeight;
        if (_isSignificantWeightChange(newWeight, currentWeight)) {
          _showGoalChangeDialog(context, newWeight > currentWeight);
          return;
        }
      }
    }

    // Proceed with normal weight update
    context.read<WeightUpdateBloc>().add(
          UpdateWeightRequested(newWeight),
        );
  }

  @override
  Widget build(BuildContext context) {
    print("current:${widget.currentWeight}");
    return BlocBuilder<GoalSettingsBloc, GoalSettingsState>(
      builder: (context, goalState) {
        if (goalState is GoalSettingsLoaded) {
          final isMetric = goalState.settings.isMetric;
          final unit = isMetric ? 'kg' : 'lbs';
          if (selectedValue.isEmpty) {
            selectedValue = goalState.settings.currentWeight.toString();
            _weightController.text = selectedValue;
          }

          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Update Weight',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: BlocListener<WeightUpdateBloc, WeightUpdateState>(
              listener: (context, state) {
                if (state is WeightUpdateSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.read<WeightHistoryBloc>().add(FetchWeightHistory());
                  context.read<HomeBloc>().add(RefreshHomeData());
                  final goalSettingsState =
                      context.read<GoalSettingsBloc>().state;
                  final double newWeight = double.parse(selectedValue);

                  if (goalSettingsState is GoalSettingsLoaded) {
                    final targetWeight = double.tryParse(
                            goalSettingsState.settings.targetWeight) ??
                        0.0;
                    // Only navigate if we're not at target weight
                    if (!((targetWeight - newWeight).abs() <= 0.1)) {
                      Navigator.of(context).pop(true);
                    }
                  } else {
                    Navigator.of(context).pop(true);
                  }
                  // Navigator.of(context).pop(true);
                } else if (state is WeightUpdateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              const SizedBox(height: 50),
                              _buildCurrentWeightDisplay(),
                              const SizedBox(height: 20),
                              Center(
                                child: AnimatedWeightPicker(
                                  showSelectedValue: false,
                                  dialColor: Colors.white,
                                  dialHeight: 70,
                                  division: isMetric ? 0.1 : 0.2,
                                  majorIntervalHeight: 24,
                                  majorIntervalColor: Colors.red,
                                  minorIntervalHeight: 14,
                                  selectedValueColor: AppColors.buttonColors,
                                  min: isMetric ? 15 : 33,
                                  max: isMetric ? 300 : 660,
                                  onChange: (newValue) {
                                    setState(() {
                                      selectedValue = newValue;
                                      _weightController.text = newValue;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                '$selectedValue $unit',
                                style: const TextStyle(
                                  fontSize: 74,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextField(
                                  controller: _weightController,
                                  focusNode: _focusNode,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: 'Enter weight in $unit',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: AppColors.buttonColors,
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    suffixText: unit,
                                    suffixStyle:
                                        const TextStyle(color: Colors.white),
                                  ),
                                  onSubmitted: (value) =>
                                      _validateAndUpdateWeight(),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      double? weight = double.tryParse(value);
                                      final minWeight = isMetric ? 15.0 : 33.0;
                                      final maxWeight =
                                          isMetric ? 300.0 : 660.0;
                                      if (weight != null &&
                                          weight >= minWeight &&
                                          weight <= maxWeight) {
                                        setState(() {
                                          selectedValue = weight.toString();
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom + 16,
                          top: 16,
                        ),
                        child: Center(
                          child:
                              BlocBuilder<WeightUpdateBloc, WeightUpdateState>(
                            builder: (context, state) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: FloatingActionButton.extended(
                                  onPressed: state is WeightUpdateLoading
                                      ? null
                                      : () => _handleWeightSubmission(
                                          context, state),
                                  backgroundColor: AppColors.buttonColors,
                                  icon: state is WeightUpdateLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.black,
                                          ),
                                        )
                                      : const Icon(Icons.check,
                                          color: Colors.black),
                                  label: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
