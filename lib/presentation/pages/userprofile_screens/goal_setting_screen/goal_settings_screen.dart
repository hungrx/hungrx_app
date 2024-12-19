import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/data/Models/profile_setting_screen/goal_settings_model.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/goal_settings_api.dart';
import 'package:hungrx_app/data/repositories/goal_settings_repository.dart';
import 'package:hungrx_app/domain/usecases/profile_setting_screen/get_goal_settings_usecase.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_bloc.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_event.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_state.dart';
import 'package:hungrx_app/routes/route_names.dart';

class GoalSettingsScreen extends StatefulWidget {
  final String? userId;

  const GoalSettingsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<GoalSettingsScreen> createState() => _GoalSettingsScreenState();
}

class _GoalSettingsScreenState extends State<GoalSettingsScreen> {
  GoalSettingsModel? _cachedSettings;
   @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoalSettingsBloc(
        GetGoalSettingsUseCase(
          GoalSettingsRepository(
            GoalSettingsApi(),
          ),
        ),
      )..add(FetchGoalSettings(widget.userId ?? "")),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: BlocConsumer<GoalSettingsBloc, GoalSettingsState>(
            listener: (context, state) {
              if (state is GoalSettingsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    action: SnackBarAction(
                      label: 'Retry',
                      onPressed: () {
                        context
                            .read<GoalSettingsBloc>()
                            .add(FetchGoalSettings(widget.userId ?? ""));
                      },
                    ),
                  ),
                );
              } else if (state is GoalSettingsLoaded) {
                _cachedSettings = state.settings;
              }
            },
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<GoalSettingsBloc>()
                      .add(FetchGoalSettings(widget.userId ?? ""));
                },
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(context),
                            const SizedBox(height: 32),
                            if (_cachedSettings != null || state is GoalSettingsLoaded)
                              Column(
                                children: [
                                  _buildTitleRow(
                                    context,
                                    (state is GoalSettingsLoaded)
                                        ? state.settings
                                        : _cachedSettings!,
                                  ),
                                  const SizedBox(height: 24),
                                  _buildGoalDetailsCard(
                                    (state is GoalSettingsLoaded)
                                        ? state.settings
                                        : _cachedSettings!,
                                  ),
                                ],
                              )
                            else
                              _buildPlaceholderContent(),
                          ],
                        ),
                      ),
                    ),
                    if (state is GoalSettingsLoading && _cachedSettings == null)
                      // _buildLoadingOverlay(),
                    if (state is GoalSettingsError && _cachedSettings == null)
                      _buildErrorOverlay(
                        "An error occurred",
                        () => context
                            .read<GoalSettingsBloc>()
                            .add(FetchGoalSettings(widget.userId ?? "")),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  //   Widget _buildLoadingOverlay() {
  //   return Container(
  //     color: Colors.black.withOpacity(0.5),
  //     child: const Center(
  //       child: CircularProgressIndicator(
  //         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildErrorOverlay(String message, VoidCallback onRetry) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Loading...',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
                'userId': widget.userId,
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
