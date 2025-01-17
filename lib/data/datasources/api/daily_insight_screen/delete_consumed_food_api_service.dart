import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/daily_insight_screen/delete_consumed_food_request.dart';

class DeleteFoodApiService {
  static const String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<DeleteFoodResponse> deleteConsumedFood(DeleteFoodRequest request) async {
    print(request.dishId);
    print(request.date);
    print(request.mealId);
    print(request.userId);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/deleteDishFromMeal'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );
print(response.body);
      if (response.statusCode == 200) {
        return DeleteFoodResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to delete food: ${response.body}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error deleting food: $e');
    }
  }
}