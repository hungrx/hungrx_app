import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/home_meals_screen/add_meal_request.dart';

class AddMealApi {
  static const String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<AddMealResponse> addMealToUser(AddMealRequest request) async {
    try {
      if (baseUrl.isEmpty) {
        throw Exception('Base URL cannot be empty');
      }

      // Construct and validate the full URL
      const url = '$baseUrl/users/addConsumedFood';
      final uri = Uri.parse(url);

      if (!uri.hasAuthority) {
        throw Exception('Invalid URL: $url');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/users/addConsumedFood'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

// print("user food consumed :${response.body}");
// print(response.statusCode);
      if (response.statusCode == 200) {
        return AddMealResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add meal: ${response.statusCode}');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid URL format: $baseUrl/users/addConsumedFood');
      } else if (e is http.ClientException) {
        throw Exception('Network error: Unable to connect to server');
      }
      throw Exception('Network error: $e');
    }
  }
}
