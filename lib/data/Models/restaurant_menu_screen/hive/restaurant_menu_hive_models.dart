import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hungrx_app/data/Models/restaurant_menu_screen/restaurant_menu_response.dart';

part 'restaurant_menu_hive_models.g.dart';

// This file defines Hive-compatible models
// Run 'flutter packages pub run build_runner build' to generate the adapters

@HiveType(typeId: 1)
class RestaurantMenuHive {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String restaurantId;
  
  @HiveField(2)
  final String jsonData;
  
  @HiveField(3)
  final DateTime timestamp;

  RestaurantMenuHive({
    required this.id,
    required this.restaurantId,
    required this.jsonData,
    required this.timestamp,
  });
  
  // Factory method to create a Hive model from the regular model
  factory RestaurantMenuHive.fromResponse({
    required String restaurantId,
    required RestaurantMenuResponse response,
  }) {
    return RestaurantMenuHive(
      id: response.menu.id,
      restaurantId: restaurantId,
      jsonData: _serializeToJson(response),
      timestamp: DateTime.now(),
    );
  }
  
  // Convert back to the regular model
  RestaurantMenuResponse toResponse() {
    final jsonMap = _deserializeFromJson(jsonData);
    return RestaurantMenuResponse.fromJson(jsonMap);
  }
  
  // Helper method to serialize response to JSON string
  static String _serializeToJson(RestaurantMenuResponse response) {
    return jsonEncode(response.toJson());
  }
  
  // Helper method to deserialize JSON string to Map
  static Map<String, dynamic> _deserializeFromJson(String jsonData) {
    return jsonDecode(jsonData) as Map<String, dynamic>;
  }
}

// Helper class for initializing Hive


// Create this in your main.dart before runApp()
// await HiveService.init();