import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/water_screen/get_water_entry_model.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/water_screen/get_water_entry_usecase.dart';
import 'package:hungrx_app/presentation/blocs/get_water_entry/get_water_entry_event.dart';
import 'package:hungrx_app/presentation/blocs/get_water_entry/get_water_entry_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetWaterIntakeBloc
    extends Bloc<GetWaterIntakeEvent, GetWaterIntakeState> {
  final GetWaterIntakeUseCase _getWaterIntakeUseCase;
  final AuthService _authService;
  Map<String, WaterIntakeData> _cachedData = {};

  GetWaterIntakeBloc(
    this._getWaterIntakeUseCase,
    this._authService,
  ) : super(GetWaterIntakeInitial()) {
    on<FetchWaterIntakeData>(_onFetchWaterIntakeData);
    on<LoadCachedWaterIntake>(_onLoadCachedWaterIntake);
  }

  Future<void> _loadCacheFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('water_intake_cache');

      if (cachedData != null) {
        final decodedData = json.decode(cachedData) as Map<String, dynamic>;
        _cachedData = decodedData.map((key, value) => MapEntry(
            key, WaterIntakeData.fromJson(value as Map<String, dynamic>)));
      }
    } catch (e) {
      debugPrint('Error loading cached water intake data: $e');
    }
  }

  Future<void> _saveCacheToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedData = json.encode(
          _cachedData.map((key, value) => MapEntry(key, value.toJson())));
      await prefs.setString('water_intake_cache', encodedData);
    } catch (e) {
      debugPrint('Error saving water intake cache: $e');
    }
  }

  Future<void> _onLoadCachedWaterIntake(
    LoadCachedWaterIntake event,
    Emitter<GetWaterIntakeState> emit,
  ) async {
    await _loadCacheFromStorage();
    final cachedResponse = _cachedData[event.date];
    if (cachedResponse != null) {
      emit(GetWaterIntakeLoaded(cachedResponse));
    }
  }

  Future<void> _onFetchWaterIntakeData(
    FetchWaterIntakeData event,
    Emitter<GetWaterIntakeState> emit,
  ) async {
    // First check and emit cached data if available
    final cachedResponse = _cachedData[event.date];
    if (cachedResponse != null) {
      emit(GetWaterIntakeLoaded(cachedResponse));
    } else {
      emit(GetWaterIntakeLoading());
    }

    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(GetWaterIntakeError('User not logged in'));
        return;
      }

      final data = await _getWaterIntakeUseCase.execute(userId, event.date);

      // Compare with cached data before emitting
      if (cachedResponse == null || !cachedResponse.equals(data)) {
        _cachedData[event.date] = data;
        await _saveCacheToStorage();
        emit(GetWaterIntakeLoaded(data));
      }
    } catch (e) {
      if (cachedResponse == null) {
        emit(GetWaterIntakeError(e.toString()));
      }
    }
  }
}
