import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/home_screen_model.dart';


class HomeApiService {
  final String baseUrl = 'https://hungerxapp.onrender.com';

  Future<HomeData> fetchHomeData(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/home'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return HomeData.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to load home data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}