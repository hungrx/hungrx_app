import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/weight_screen/weight_history_model.dart';
import 'package:hungrx_app/data/datasources/api/weight_screen/weight_history_api.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/weight_screen/get_weight_history_usecase.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_event.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightHistoryBloc extends Bloc<WeightHistoryEvent, WeightHistoryState> {
  final GetWeightHistoryUseCase _getWeightHistoryUseCase;
  final AuthService _authService;
  WeightHistoryModel? _cachedWeightHistory;

  WeightHistoryBloc(
    this._getWeightHistoryUseCase,
    this._authService,
  ) : super(WeightHistoryInitial()) {
    on<FetchWeightHistory>(_onFetchWeightHistory);
    on<LoadCachedWeightHistory>(_onLoadCachedWeightHistory);
  }

  Future<void> _loadCacheFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('weight_history_cache');
      
      if (cachedData != null) {
        final jsonData = json.decode(cachedData);
        _cachedWeightHistory = WeightHistoryModel.fromJson(jsonData);
      }
    } catch (e) {
      debugPrint('Error loading cached weight history: $e');
    }
  }

  Future<void> _saveCacheToStorage(WeightHistoryModel weightHistory) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('weight_history_cache', json.encode(weightHistory.toJson()));
    } catch (e) {
      debugPrint('Error saving weight history cache: $e');
    }
  }

  Future<void> _onLoadCachedWeightHistory(
    LoadCachedWeightHistory event,
    Emitter<WeightHistoryState> emit,
  ) async {
    await _loadCacheFromStorage();
    if (_cachedWeightHistory != null) {
      emit(WeightHistoryLoaded(_cachedWeightHistory!));
    }
  }

  Future<void> _onFetchWeightHistory(
    FetchWeightHistory event,
    Emitter<WeightHistoryState> emit,
  ) async {
    // First emit cached data if available
    if (_cachedWeightHistory != null) {
      emit(WeightHistoryLoaded(_cachedWeightHistory!));
    } else {
      emit(WeightHistoryLoading());
    }

    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(WeightHistoryError('User not logged in'));
        return;
      }

      final weightHistory = await _getWeightHistoryUseCase.execute(userId);

      // Compare with cached data before emitting
      if (_cachedWeightHistory == null || !_cachedWeightHistory!.equals(weightHistory)) {
        _cachedWeightHistory = weightHistory;
        await _saveCacheToStorage(weightHistory);
        emit(WeightHistoryLoaded(weightHistory));
      }
    } catch (e) {
      if (_cachedWeightHistory == null) {
        if (e is NoWeightRecordsException) {
          emit(WeightHistoryNoRecords());
        }
        emit(WeightHistoryError(e.toString()));
      }
    }
  }
}
