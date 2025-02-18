import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';

class TimezoneApi {
  final http.Client client;

  TimezoneApi({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> updateTimezone(String userId, String timezone) async {
   
   print("time :$timezone");
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/users/timezone'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'timezone': timezone,
        }),
      );
print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update timezone: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}