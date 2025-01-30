import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/daily_insight_screen/delete_consumed_food_request.dart';

class DeleteFoodApiService {
  Future<DeleteFoodResponse> deleteConsumedFood(
      DeleteFoodRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.deleteDishFromMeal),
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
