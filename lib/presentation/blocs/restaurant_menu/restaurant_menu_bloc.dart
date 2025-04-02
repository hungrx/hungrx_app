import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/hive/restaurant_menu_hive_models.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/restaurant_menu_response.dart';
import 'package:hungrx_app/data/repositories/restaurant_menu_screen/restaurant_menu_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_event.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_state.dart';

class RestaurantMenuBloc
    extends Bloc<RestaurantMenuEvent, RestaurantMenuState> {
  final RestaurantMenuRepository repository;
  final AuthService _authService;
  final Map<String, RestaurantMenuResponse> _memoryCache = {};
  static const cacheDuration = Duration(minutes: 30);
  static const String menuBoxName = 'restaurant_menus';
  static const String timestampBoxName = 'restaurant_menu_timestamps';

  RestaurantMenuBloc({
    required this.repository,
    required AuthService authService,
  })  : _authService = authService,
        super(RestaurantMenuInitial()) {
    on<LoadRestaurantMenu>(_onLoadRestaurantMenu);
    on<LoadCachedRestaurantMenu>(_onLoadCachedRestaurantMenu);
  }

  Box<RestaurantMenuHive> get _menuBox =>
      Hive.box<RestaurantMenuHive>(menuBoxName);
  Box<String> get _timestampBox => Hive.box<String>(timestampBoxName);

  Future<void> _onLoadCachedRestaurantMenu(
    LoadCachedRestaurantMenu event,
    Emitter<RestaurantMenuState> emit,
  ) async {
    // First check in-memory cache for quicker access
    if (_memoryCache.containsKey(event.restaurantId)) {
      emit(RestaurantMenuLoaded(_memoryCache[event.restaurantId]!));
      return;
    }

    // Check persistent Hive cache
    final cachedMenu = _menuBox.get(event.restaurantId);
    final lastFetchTime = _getLastFetchTime(event.restaurantId);

    if (cachedMenu != null && lastFetchTime != null) {
      if (DateTime.now().difference(lastFetchTime) < cacheDuration) {
        final menuResponse = cachedMenu.toResponse();
        // Update in-memory cache
        _memoryCache[event.restaurantId] = menuResponse;
        emit(RestaurantMenuLoaded(menuResponse));
      }
    }
  }

  DateTime? _getLastFetchTime(String restaurantId) {
    try {
      final timestampStr = _timestampBox.get(restaurantId);
      if (timestampStr != null) {
        return DateTime.parse(timestampStr);
      }
      return null;
    } catch (e) {
      debugPrint('Error parsing timestamp: $e');
      return null;
    }
  }

  Future<void> _setLastFetchTime(String restaurantId) async {
    await _timestampBox.put(restaurantId, DateTime.now().toIso8601String());
  }

  Future<void> _saveToHiveCache(
      String restaurantId, RestaurantMenuResponse response) async {
    try {
      final hiveModel = RestaurantMenuHive.fromResponse(
        restaurantId: restaurantId,
        response: response,
      );

      await _menuBox.put(restaurantId, hiveModel);
      await _setLastFetchTime(restaurantId);

      // Update in-memory cache
      _memoryCache[restaurantId] = response;
    } catch (e) {
      debugPrint('Error saving to Hive cache: $e');
    }
  }

  Future<void> _onLoadRestaurantMenu(
    LoadRestaurantMenu event,
    Emitter<RestaurantMenuState> emit,
  ) async {
    // First check in-memory cache
    RestaurantMenuResponse? cachedResponse = _memoryCache[event.restaurantId];

    // If not in memory, check Hive
    if (cachedResponse == null) {
      final hiveCache = _menuBox.get(event.restaurantId);
      if (hiveCache != null) {
        cachedResponse = hiveCache.toResponse();
        _memoryCache[event.restaurantId] = cachedResponse;
      }
    }

    final lastFetchTime = _getLastFetchTime(event.restaurantId);
    bool shouldFetchFreshData = true;

    if (cachedResponse != null && lastFetchTime != null) {
      final timeSinceLastFetch = DateTime.now().difference(lastFetchTime);

      if (timeSinceLastFetch < cacheDuration) {
        // Cache is valid, emit it immediately
        emit(RestaurantMenuLoaded(cachedResponse));

        // If we fetched recently, don't fetch again
        if (timeSinceLastFetch < const Duration(seconds: 30)) {
          shouldFetchFreshData = false;
        }
      } else {
        // Cache is expired but still usable while we fetch new data
        emit(RestaurantMenuLoaded(cachedResponse));
      }
    } else {
      // No cache available, show loading
      emit(RestaurantMenuLoading());
    }

    if (!shouldFetchFreshData) {
      return;
    }

    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        if (cachedResponse == null) {
          emit(RestaurantMenuError('User not logged in'));
        }
        return;
      }

      final freshData = await repository.getMenu(
        event.restaurantId,
        userId,
      );

      // IMPORTANT: Always update cache if we get new data from server
      // Don't compare with cached data, always treat server response as the truth
      await _saveToHiveCache(event.restaurantId, freshData);
      emit(RestaurantMenuLoaded(freshData));
    } catch (e) {
      debugPrint('Error fetching menu: $e');
      if (cachedResponse == null) {
        emit(RestaurantMenuError(e.toString()));
      }
      // If we have cached data, don't emit error
    }
  }

  // This method is no longer needed as we're always updating the cache
  // But keeping it in case we need it for other use cases later

  // Clear cache methods
  Future<void> clearCache(String restaurantId) async {
    _memoryCache.remove(restaurantId);
    await _menuBox.delete(restaurantId);
    await _timestampBox.delete(restaurantId);
  }

  Future<void> clearAllCache() async {
    _memoryCache.clear();
    await _menuBox.clear();
    await _timestampBox.clear();
  }
}
