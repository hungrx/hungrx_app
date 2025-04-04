import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/custom_food_entry_response.dart';

class CustomFoodEntryApi {
  Future<CustomFoodEntryResponse> addCustomFood({
    required String userId,
    required String mealType,
    required String foodName,
    required String calories,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.addUnknown),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'mealType': mealType,
          'foodName': foodName,
          'calories': calories,
        }),
      );
print(response.body);
      if (response.statusCode == 200) {
        return CustomFoodEntryResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add custom food: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Network error: $e');
    }
  }
}