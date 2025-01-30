import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';

class GoalSettingsApi {
  Future<Map<String, dynamic>> fetchGoalSettings(String userId) async {
    print(userId);
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.goalSetting),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true) {
          return data['data'];
        }
        throw Exception('Failed to fetch goal settings: ${data['message']}');
      }
      throw Exception('Failed to fetch goal settings');
    } catch (e) {
      print(e);
      throw Exception('Network error: $e');
    }
  }
}