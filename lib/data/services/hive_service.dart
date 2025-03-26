import 'package:hive_flutter/hive_flutter.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/hive/restaurant_menu_hive_models.dart';

class HiveService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Register adapters safely
    if (!_isAdapterRegistered(1)) {
      Hive.registerAdapter(RestaurantMenuHiveAdapter());
    }

    // Open boxes
    await Hive.openBox<RestaurantMenuHive>('restaurant_menus');
    await Hive.openBox<String>('restaurant_menu_timestamps');

    _initialized = true;
  }

  // Helper method to check if an adapter is already registered
  static bool _isAdapterRegistered(int typeId) {
    try {
      return Hive.isAdapterRegistered(typeId);
    } catch (_) {
      // If the method doesn't exist in this Hive version
      return false;
    }
  }
}
