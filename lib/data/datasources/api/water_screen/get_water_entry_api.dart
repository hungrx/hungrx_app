import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/water_screen/get_water_entry_model.dart';

class GetWaterIntakeApi {
  Future<WaterIntakeData> getWaterIntakeData(String userId, String date) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.getWaterIntakeData),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'date': date,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          return WaterIntakeData.fromJson(jsonResponse['data']);
        } else {
          throw Exception('API request failed: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load water intake data');
      }
    } catch (e) {
      throw Exception('Error fetching water intake data: $e');
    }
  }
}
