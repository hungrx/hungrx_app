import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/weight_response_model.dart';
import 'package:hungrx_app/data/Models/weight_update_model.dart';

class WeightUpdateApiService {
  static const String baseUrl = 'https://hungerxapp.onrender.com';

  Future<WeightUpdateResponse> updateWeight(WeightUpdateModel weightUpdate) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/updateWeight'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(weightUpdate.toJson()),
      );
print(response.body);
      if (response.statusCode == 200) {
        return WeightUpdateResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update weight: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}