import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/home_meals_screen/common_food_model.dart';

class CommonFoodApi {
  static const String baseUrl = 'https://hungrxbackend.onrender.com/users';

Future<List<CommonFoodModel>> searchCommonFood(String query) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/searchCommonfood'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': query}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // print('API Response: ${response.body}'); // Add this line for debugging
      if (data['status'] == true) {
        return (data['data'] as List)
            .map((item) => CommonFoodModel.fromJson(item))
            .toList();
      }
      throw Exception('Search failed: ${data['message']}');
    }
    throw Exception('Failed to search common food');
  } catch (e) {
    print('Error in searchCommonFood: $e'); // Enhanced error logging
    throw Exception('Error searching common food: $e');
  }
}
}