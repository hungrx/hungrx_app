import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/dialy_activity_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/goal_selection_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/navigation_buttons.dart';
import 'package:hungrx_app/presentation/pages/health_profile_screens/widgets/prograss_indicator.dart';

class GoalPaceScreen extends StatefulWidget {
  final WeightGoal goal;
  final double currentWeight;
  final double goalWeight;

  const GoalPaceScreen({
    super.key,
    required this.goal,
    required this.currentWeight,
    required this.goalWeight,
  });

  @override
  GoalPaceScreenState createState() => GoalPaceScreenState();
}

class GoalPaceScreenState extends State<GoalPaceScreen> {
  double paceValue = 2.0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GradientContainer(
        top: size.height * 0.06,
        left: size.height * 0.01,
        right: size.height * 0.01,
        bottom: size.height * 0.01,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SteppedProgressBar(
                  currentStep: 5,
                  totalSteps: 6,
                ),
                const SizedBox(height: 40),
                Text(
                  _getTitle(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _getSuggestion(),
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                Center(
                  child: Text(
                    _getPaceText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'per week',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Slider(
                  value: paceValue,
                  min: 1,
                  max: 4,
                  divisions: 3,
                  activeColor: AppColors.buttonColors,
                  inactiveColor: Colors.grey[800],
                  onChanged: (value) {
                    setState(() {
                      paceValue = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _getPaceLabels(),
                ),
                const Spacer(),
                Center(
                  child: Container(
                    // margin: EdgeInsets.all(10),
                    padding: const EdgeInsets.all(15),
                    decoration:  BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: widget.goal == WeightGoal.maintain ? Colors.transparent : const Color.fromARGB(255, 49, 54, 43)),
                    child: Text(
                      _getEstimatedTimeToGoal(),
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                NavigationButtons(
                  onNextPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DailyActivityScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (widget.goal) {
      case WeightGoal.lose:
        return 'How fast do you want to\nlose weight?';
      case WeightGoal.gain:
        return 'How fast do you want to\ngain weight?';
      case WeightGoal.maintain:
        return 'Maintain your current\nweight';
    }
  }

  String _getPaceText() {
    if (widget.goal == WeightGoal.maintain) {
      return '0 Kg';
    }
    double pace = (paceValue - 1) * 0.25 + 0.25; // 0.25, 0.5, 0.75, or 1 kg
    return '${pace.toStringAsFixed(2)} Kg';
  }

  List<Widget> _getPaceLabels() {
    if (widget.goal == WeightGoal.maintain) {
      return [const Text('Maintain', style: TextStyle(color: Colors.grey))];
    }
    return ['Mild', 'Moderate', 'Fast', 'Very Fast']
        .map((e) => Text(
              e,
              style: const TextStyle(color: Colors.grey),
            ))
        .toList();
  }

  String _getSuggestion() {
    if (widget.goal == WeightGoal.maintain) {
      return "Maintaining your current weight is a great way to stay healthy.";
    }

    switch (paceValue.toInt()) {
      case 1:
        return "This is a slow but very sustainable pace to reach your goal weight.";
      case 2:
        return "This is a good, sustainable pace to reach your goal weight.";
      case 3:
        return "This is a challenging but achievable pace. Make sure to stay consistent!";
      case 4:
        return "This is a very fast pace. It may be difficult to maintain. Consider a slower pace for long-term success.";
      default:
        return "";
    }
  }

  String _getEstimatedTimeToGoal() {
    if (widget.goal == WeightGoal.maintain) {
      return "";
    }

    double weeklyPace = (paceValue - 1) * 0.25 + 0.25;
    double weightDifference = (widget.goalWeight - widget.currentWeight).abs();
    int weeksToGoal = (weightDifference / weeklyPace).ceil();
    int monthsToGoal = (weeksToGoal / 4).ceil();

    if (monthsToGoal < 1) {
      return "You will reach your goal in less than a month!";
    } else if (monthsToGoal == 1) {
      return "You will reach your goal in about 1 month.";
    } else {
      return "You will reach your goal in about $monthsToGoal months.";
    }
  }
}
