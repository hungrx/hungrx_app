import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hungrx_app/data/Models/dashboad_screen/home_screen_model.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthService _authService;
  HomeData? _cachedHomeData;

  HomeBloc(this._authService) : super(HomeInitial()) {
    on<InitializeHomeData>(_onInitializeHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<LoadCachedHomeData>(_onLoadCachedHomeData);
  }

  Future<void> _loadCacheFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('home_data_cache');
      
      if (cachedData != null) {
        final jsonData = json.decode(cachedData);
        _cachedHomeData = HomeData.fromJson(jsonData);
      }
    } catch (e) {
      debugPrint('Error loading cached home data: $e');
    }
  }

  Future<void> _saveCacheToStorage(HomeData homeData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('home_data_cache', json.encode(homeData.toJson()));
    } catch (e) {
      debugPrint('Error saving home data cache: $e');
    }
  }

  Future<void> _onLoadCachedHomeData(
    LoadCachedHomeData event,
    Emitter<HomeState> emit,
  ) async {
    await _loadCacheFromStorage();
    if (_cachedHomeData != null) {
      emit(HomeLoaded(_cachedHomeData!));
    }
  }

  void _onInitializeHomeData(
    InitializeHomeData event,
    Emitter<HomeState> emit,
  ) async {
    _cachedHomeData = event.homeData;
    await _saveCacheToStorage(event.homeData);
    emit(HomeLoaded(event.homeData));
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    // First emit cached data if available
    if (_cachedHomeData != null) {
      emit(HomeLoaded(_cachedHomeData!));
    } else {
      emit(HomeLoading());
    }

    try {
      final homeData = await _authService.fetchHomeData();
      if (homeData != null) {
        // Compare with cached data before emitting
        if (_cachedHomeData == null || !_cachedHomeData!.equals(homeData)) {
          _cachedHomeData = homeData;
          await _saveCacheToStorage(homeData);
          emit(HomeLoaded(homeData));
        }
      } else {
        if (_cachedHomeData == null) {
          emit(HomeError('Failed to refresh home data'));
        }
      }
    } catch (e) {
      if (_cachedHomeData == null) {
        emit(HomeError(e.toString()));
      }
    }
  }
}