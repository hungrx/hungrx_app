import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/water_screen/add_water_response.dart';

class WaterIntakeApi {
  final http.Client client;

  WaterIntakeApi({required this.client});

  Future<AddWaterResponse> addWaterIntake({
    required String userId,
    required String amount,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.addWater),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'amountInMl': amount,
        }),
      );
      print(response.body);

      if (response.statusCode == 200) {
        return AddWaterResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add water intake: ${response.body}');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to connect to server: $e');
    }
  }
}
