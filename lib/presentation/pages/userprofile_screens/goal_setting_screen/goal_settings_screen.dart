import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/data/Models/goal_settings_model.dart';
import 'package:hungrx_app/data/datasources/api/goal_settings_api.dart';
import 'package:hungrx_app/data/repositories/goal_settings_repository.dart';
import 'package:hungrx_app/domain/usecases/get_goal_settings_usecase.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_bloc.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_event.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_state.dart';
import 'package:hungrx_app/routes/route_names.dart';

class GoalSettingsScreen extends StatelessWidget {
  final String? userId;

  const GoalSettingsScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoalSettingsBloc(
        GetGoalSettingsUseCase(
          GoalSettingsRepository(
            GoalSettingsApi(),
          ),
        ),
      )..add(FetchGoalSettings(userId??"")),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: BlocConsumer<GoalSettingsBloc, GoalSettingsState>(
            listener: (context, state) {
              if (state is GoalSettingsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is GoalSettingsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GoalSettingsLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 32),
                      _buildTitleRow(context, state.settings),
                      const SizedBox(height: 24),
                      _buildGoalDetailsCard(state.settings),
                    ],
                  ),
                );
              }

              return const Center(child: Text('No data available'));
            },
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
          'Goal Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleRow(BuildContext context, GoalSettingsModel settings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Weight Goal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            context.pushNamed(
              RouteNames.editGoalSettings,
              extra: {
                'userId': userId,
                'goal': settings.goal,
                'targetWeight': settings.targetWeight,
                'isMetric': settings.isMetric,
                'currentWeight': settings.currentWeight,
                'weightGainRate': settings.weightGainRate,
                'activityLevel': settings.activityLevel,
                'mealsPerDay': settings.mealsPerDay,
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFBBD66F),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit, size: 16, color: Colors.black),
                SizedBox(width: 4),
                Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalDetailsCard(GoalSettingsModel settings) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow('Goal', settings.goal),
          const SizedBox(height: 20),
          _buildInfoRow('Target Weight', '${settings.targetWeight}kg'),
          const SizedBox(height: 20),
          _buildInfoRow('Goal pace', '${settings.weightGainRate}kg / week'),
          const SizedBox(height: 20),
          _buildInfoRow('Activity level', settings.activityLevel),
          const SizedBox(height: 20),
          _buildInfoRow('Meals per day', '${settings.mealsPerDay} times'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
