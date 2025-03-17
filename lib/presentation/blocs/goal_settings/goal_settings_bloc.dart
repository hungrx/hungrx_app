import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/profile_setting_screen/goal_settings_model.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/profile_setting_screen/get_goal_settings_usecase.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_event.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalSettingsBloc extends Bloc<GoalSettingsEvent, GoalSettingsState> {
  final GetGoalSettingsUseCase _getGoalSettingsUseCase;
  final AuthService _authService;
  GoalSettingsModel? _cachedSettings;

  GoalSettingsBloc(
    this._getGoalSettingsUseCase,
    this._authService,
  ) : super(GoalSettingsInitial()) {
    on<FetchGoalSettings>(_onFetchGoalSettings);
    on<ClearGoalSettings>(_onClearGoalSettings);
    on<LoadCachedGoalSettings>(_onLoadCachedGoalSettings);
  }

  Future<void> _onLoadCachedGoalSettings(
    LoadCachedGoalSettings event,
    Emitter<GoalSettingsState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('goal_settings_cache');

      if (cachedData != null) {
        final jsonData = json.decode(cachedData);
        _cachedSettings = GoalSettingsModel.fromJson(jsonData);
        emit(GoalSettingsLoaded(_cachedSettings!));
      }
    } catch (e) {
      debugPrint('Error loading cached goal settings: $e');
    }
  }

  Future<void> _onFetchGoalSettings(
    FetchGoalSettings event,
    Emitter<GoalSettingsState> emit,
  ) async {
    // If we have cached data, emit it first
    if (_cachedSettings != null) {
      emit(GoalSettingsLoaded(_cachedSettings!));
    } else {
      emit(GoalSettingsLoading());
    }

    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(GoalSettingsError('User not logged in'));
        return;
      }

      final settings = await _getGoalSettingsUseCase.execute(userId);
      
      // Compare with cached data before emitting
      if (_cachedSettings == null || !_cachedSettings!.equals(settings)) {
        _cachedSettings = settings;
        emit(GoalSettingsLoaded(settings));
        
        // Update cache
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('goal_settings_cache', json.encode(settings.toJson()));
      }
    } catch (e) {
      if (_cachedSettings == null) {
        emit(GoalSettingsError(e.toString()));
      }
    }
  }

  void _onClearGoalSettings(
    ClearGoalSettings event,
    Emitter<GoalSettingsState> emit,
  ) async {
    _cachedSettings = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('goal_settings_cache');
    emit(GoalSettingsInitial());
  }
}