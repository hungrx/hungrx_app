import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/dashboad_screen/streak_data_model.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/dashboad_screen/get_streak_usecase.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_event.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_state.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  final GetStreakUseCase _getStreakUseCase;
  final AuthService _authService;
  StreakDataModel? _cachedStreak;

  StreakBloc(this._getStreakUseCase, this._authService)
      : super(StreakInitial()) {
    on<FetchStreakData>(_onFetchStreakData);
    on<LoadCachedStreak>(_onLoadCachedStreak);
  }

  Future<void> _loadCacheFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('streak_cache');

      if (cachedData != null) {
        final jsonData = json.decode(cachedData);
        _cachedStreak = StreakDataModel.fromJson(jsonData);
      }
    } catch (e) {
      debugPrint('Error loading cached streak data: $e');
    }
  }

  Future<void> _saveCacheToStorage(StreakDataModel streak) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('streak_cache', json.encode(streak.toJson()));
    } catch (e) {
      debugPrint('Error saving streak cache: $e');
    }
  }

  Future<void> _onLoadCachedStreak(
    LoadCachedStreak event,
    Emitter<StreakState> emit,
  ) async {
    await _loadCacheFromStorage();
    if (_cachedStreak != null && _isStreakValid(_cachedStreak!)) {
      emit(StreakLoaded(_cachedStreak!));
    }
  }

  Future<void> _onFetchStreakData(
    FetchStreakData event,
    Emitter<StreakState> emit,
  ) async {
    // First check and emit cached data if available
    if (_cachedStreak != null && _isStreakValid(_cachedStreak!)) {
      emit(StreakLoaded(_cachedStreak!));
    } else {
      emit(StreakLoading());
    }

    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(StreakError('User not logged in'));
        return;
      }

      final streakData = await _getStreakUseCase.execute(userId);

      // Compare with cached data before emitting
      if (_cachedStreak == null || !_cachedStreak!.equals(streakData)) {
        _cachedStreak = streakData;
        await _saveCacheToStorage(streakData);
        emit(StreakLoaded(streakData));
      }
    } catch (e) {
      if (_cachedStreak == null) {
        emit(StreakError(e.toString()));
      }
    }
  }

  bool _isStreakValid(StreakDataModel streak) {
    // Check if the streak data is from today
    final lastDate = streak.dates.isNotEmpty ? streak.dates.last : null;
    if (lastDate == null) return false;

    final today = DateFormat('dd/MM/yyyy').format(DateTime.now());
    return lastDate == today;
  }
}
