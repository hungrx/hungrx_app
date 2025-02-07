import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';

class MealTypeApi {
  final http.Client client;

  MealTypeApi({required this.client});

  Future<List<Map<String, dynamic>>> getMealTypes() async {
    try {
      final response = await client.get(Uri.parse(ApiConstants.getMeals));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        throw Exception(data['message']);
      }
      throw Exception('Failed to fetch meal types');
    } catch (e) {
      print(e);
      throw Exception('Network error: $e');
    }
  }
}