import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/tdee_result_model.dart';
import 'package:hungrx_app/presentation/blocs/result_bloc/result_bloc.dart';
import 'package:hungrx_app/presentation/blocs/result_bloc/result_event.dart';
import 'package:hungrx_app/presentation/blocs/result_bloc/result_state.dart';

class TDEEResultScreen extends StatefulWidget {
  final String userId;

  const TDEEResultScreen({super.key, required this.userId});

  @override
  TDEEResultScreenState createState() => TDEEResultScreenState();
}

class TDEEResultScreenState extends State<TDEEResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _fetchData();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    );
  }

  void _fetchData() {
    
    context.read<TDEEBloc>().add(CalculateTDEE(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<TDEEBloc, TDEEState>(
        builder: (context, state) {
          if (state is TDEELoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TDEELoaded) {
            _controller.forward();
            return _buildContent(state);
          } else if (state is TDEEError) {
            return Center(child: Text('Error: ${state.message}', 
                                    style: const TextStyle(color: Colors.white)));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildContent(TDEELoaded state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildResults(state.result),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.buttonColors,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.buttonColors.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 60),
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: _opacityAnimation,
            child: const Text(
              'Your Results Are Ready!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonColors,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(TDEEResultModel result) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Column(
        children: [
          _buildResultCard('Height', result.height),
          _buildResultCard('Weight', result.weight),
          _buildResultCard('BMI', result.bmi),
          _buildResultCard('BMR', result.bmr),
          _buildResultCard('TDEE', result.tdee),
          _buildResultCard('Daily Calorie Goal', result.dailyCaloriesGoal),
          _buildResultCard('Calories to Goal', result.caloriesToReachGoal),
          _buildResultCard('Days to Goal', result.daysToReachGoal),
          _buildResultCard('Goal Pace', result.goalPace),
        ],
      ),
    );
  }

  Widget _buildResultCard(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}