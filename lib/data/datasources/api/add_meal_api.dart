import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/add_meal_request.dart';

class AddMealApi {
  static const String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<AddMealResponse> addMealToUser(AddMealRequest request) async {
    try {
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
      throw Exception('Network error: $e');
    }
  }
}