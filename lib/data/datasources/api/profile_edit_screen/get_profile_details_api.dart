import 'dart:convert';
import 'package:http/http.dart' as http;

class GetProfileDetailsApi {
  Future<Map<String, dynamic>> getProfileDetails(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('https://hungrxbackend.onrender.com/users/profileScreen'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return data['data'];
        }
        throw Exception('Invalid data format');
      }
      throw Exception('Failed to load profile details');
    } catch (e) {
      print(e);
      throw Exception('Network error: $e');
    }
  }
}