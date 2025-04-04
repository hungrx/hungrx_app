import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/dashboad_screen/home_screen_model.dart';

class HomeApiService {
  Future<HomeData> fetchHomeData(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.homeScreen),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;

        // Verify that the response has the expected structure
        if (!jsonData['status']) {
          throw Exception('API returned status false');
        }

        if (jsonData['data'] == null) {
          throw Exception('API returned null data');
        }

        return HomeData.fromJson(jsonData['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load home data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch home data: $e');
    }
  }
}
