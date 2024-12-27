import 'package:flutter/widgets.dart';
import 'package:hungrx_app/data/datasources/api/dashboard_screen/home_screen_api_service.dart';
import 'package:hungrx_app/data/repositories/home_screen_repository.dart';

class HomeDataNotifier {
  
  static final ValueNotifier<double> caloriesNotifier = ValueNotifier(0.0);
  
  static void updateCalories(double newValue) {
    caloriesNotifier.value = newValue;
  }
  
  static void decreaseCalories(double consumedCalories) {
    caloriesNotifier.value = caloriesNotifier.value - 500;
  }
   static Future<void> fetchInitialData(String userId) async {
       final HomeApiService homeApiService = HomeApiService();
    try {
      final response = await HomeRepository(homeApiService).getHomeData(userId);
      updateCalories(response.remaining.toDouble());
    } catch (e) {
      // print('Error fetching initial data: $e');
    }
  }
}