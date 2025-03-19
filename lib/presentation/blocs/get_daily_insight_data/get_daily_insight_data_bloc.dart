import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/daily_insight_screen/daily_food_response.dart';
import 'package:hungrx_app/data/repositories/daily_insight_screen/daily_insight_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/get_daily_insight_data/get_daily_insight_data_event.dart';
import 'package:hungrx_app/presentation/blocs/get_daily_insight_data/get_daily_insight_data_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyInsightBloc extends Bloc<DailyInsightEvent, DailyInsightState> {
  final DailyInsightRepository repository;
  final AuthService authService;
  Map<String, DailyFoodResponse> _cachedData = {};

  DailyInsightBloc(this.repository, this.authService) : super(DailyInsightInitial()) {
    on<GetDailyInsightData>(_onGetDailyInsightData);
    on<LoadCachedDailyInsight>(_onLoadCachedDailyInsight);
  }

  Future<void> _loadCacheFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('daily_insight_cache');
      
      if (cachedData != null) {
        final decodedData = json.decode(cachedData) as Map<String, dynamic>;
        _cachedData = decodedData.map((key, value) => 
          MapEntry(key, DailyFoodResponse.fromJson(value as Map<String, dynamic>)));
      }
    } catch (e) {
      debugPrint('Error loading cached daily insight data: $e');
    }
  }

  Future<void> _saveCacheToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedData = json.encode(
        _cachedData.map((key, value) => MapEntry(key, value.toJson()))
      );
      await prefs.setString('daily_insight_cache', encodedData);
    } catch (e) {
      debugPrint('Error saving daily insight cache: $e');
    }
  }

  Future<void> _onLoadCachedDailyInsight(
    LoadCachedDailyInsight event,
    Emitter<DailyInsightState> emit,
  ) async {
    await _loadCacheFromStorage();
    final cachedResponse = _cachedData[event.date];
    if (cachedResponse != null) {
      emit(DailyInsightLoaded(cachedResponse));
    }
  }

  Future<void> _onGetDailyInsightData(
    GetDailyInsightData event,
    Emitter<DailyInsightState> emit,
  ) async {
    // First check and emit cached data if available
    final cachedResponse = _cachedData[event.date];
    if (cachedResponse != null) {
      emit(DailyInsightLoaded(cachedResponse));
    } else {
      emit(DailyInsightLoading());
    }

    try {
      final userId = await authService.getUserId();
      if (userId == null) {
        emit(DailyInsightError('User not logged in'));
        return;
      }

      final data = await repository.getDailyInsightData(
        userId: userId,
        date: event.date,
      );

      // Compare with cached data before emitting
      if (cachedResponse == null || !_compareDailyFoodResponses(cachedResponse, data)) {
        _cachedData[event.date] = data;
        await _saveCacheToStorage();
        emit(DailyInsightLoaded(data));
      }
    } catch (e) {
      if (cachedResponse == null) {
        emit(DailyInsightError(e.toString()));
      }
    }
  }

  bool _compareDailyFoodResponses(DailyFoodResponse cached, DailyFoodResponse fresh) {
    return cached.date == fresh.date &&
           cached.dailySummary.totalCalories == fresh.dailySummary.totalCalories &&
           cached.dailySummary.remaining == fresh.dailySummary.remaining;
  }
}