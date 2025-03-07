import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/common_food_model.dart';

class CommonFoodApi {
  Future<List<CommonFoodModel>> searchCommonFood(String query) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.searchCommonfood),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': query}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true) {
          return (data['data'] as List)
              .map((item) => CommonFoodModel.fromJson(item))
              .toList();
        }
        throw Exception('Search failed: ${data['message']}');
      }
      throw Exception('Failed to search common food');
    } catch (e) {
      // Enhanced error logging
      throw Exception('Error searching common food: $e');
    }
  }
}
