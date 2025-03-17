import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/profile_screen/get_basic_info_response.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/get_basic_info_usecase.dart';
import 'package:hungrx_app/presentation/blocs/get_basic_info/get_basic_info_event.dart';
import 'package:hungrx_app/presentation/blocs/get_basic_info/get_basic_info_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetBasicInfoBloc extends Bloc<GetBasicInfoEvent, GetBasicInfoState> {
  final GetBasicInfoUseCase _useCase;
  final AuthService _authService;
  UserBasicInfo? _cachedBasicInfo;

  GetBasicInfoBloc(
    this._useCase,
    this._authService,
  ) : super(GetBasicInfoInitial()) {
    on<GetBasicInfoRequested>(_onGetBasicInfoRequested);
    on<LoadCachedBasicInfo>(_onLoadCachedBasicInfo);
  }

  Future<void> _onLoadCachedBasicInfo(
    LoadCachedBasicInfo event,
    Emitter<GetBasicInfoState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('basic_info_cache');

      if (cachedData != null) {
        final jsonData = json.decode(cachedData);
        _cachedBasicInfo = UserBasicInfo.fromJson(jsonData);
        emit(GetBasicInfoSuccess(_cachedBasicInfo!));
      }
    } catch (e) {
      debugPrint('Error loading cached basic info: $e');
    }
  }

  Future<void> _onGetBasicInfoRequested(
    GetBasicInfoRequested event,
    Emitter<GetBasicInfoState> emit,
  ) async {
    // If we have cached data, emit it first
    if (_cachedBasicInfo != null) {
      emit(GetBasicInfoSuccess(_cachedBasicInfo!));
    } else {
      emit(GetBasicInfoLoading());
    }

    try {
      final userId = await _authService.getUserId();
      
      if (userId == null) {
        emit(GetBasicInfoFailure('User not logged in'));
        return;
      }

      final response = await _useCase.execute(userId);
      
      // Compare with cached data before emitting
      if (_cachedBasicInfo == null || 
          !_compareBasicInfo(_cachedBasicInfo!, response.data)) {
        _cachedBasicInfo = response.data;
        emit(GetBasicInfoSuccess(response.data));
        
        // Update cache
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('basic_info_cache', 
          json.encode(response.data.toJson()));
      }
    } catch (e) {
      if (_cachedBasicInfo == null) {
        emit(GetBasicInfoFailure(e.toString()));
      }
    }
  }

  bool _compareBasicInfo(UserBasicInfo cached, UserBasicInfo fresh) {
    return cached.name == fresh.name &&
        cached.email == fresh.email &&
        cached.gender == fresh.gender &&
        cached.phone == fresh.phone &&
        cached.age == fresh.age &&
        cached.heightInCm == fresh.heightInCm &&
        cached.heightInFeet == fresh.heightInFeet &&
        cached.heightInInches == fresh.heightInInches &&
        cached.weightInKg == fresh.weightInKg &&
        cached.weightInLbs == fresh.weightInLbs &&
        cached.targetWeight == fresh.targetWeight &&
        cached.isMetric == fresh.isMetric;
  }
}