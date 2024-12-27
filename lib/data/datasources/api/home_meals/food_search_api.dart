import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/food_item_model.dart';

class FoodSearchApi {
  final http.Client client = http.Client();

  Future<List<FoodItemModel>> searchFood(String query) async {
    // print(query);
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.grocerySearch),
        body: json.encode({'name': query}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      // print('Response status code: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((item) => FoodItemModel.fromJson(item))
              .toList();
        } else {
          throw Exception('Invalid response format or empty data');
        }
      }

      throw Exception(
        'Server error: ${response.statusCode}\nResponse: ${response.body}',
      );
    } catch (e) {
      // print('Error in searchFood: $e');
      throw Exception('Network error: $e');
    } finally {
      // Optional: Close the client if you're not reusing it
      // client.close();
    }
  }
}
