import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/update_goal_settings_model.dart';

class UpdateGoalSettingsApi {
  static const String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<Map<String, dynamic>> updateGoalSettings(UpdateGoalSettingsModel settings) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/updateGoalSetting'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(settings.toJson()),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update goal settings: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating goal settings: $e');
    }
  }
}