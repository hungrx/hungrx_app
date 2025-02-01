import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/common_food/add_common_food_history_request.dart';

class AddCommonFoodHistoryApi {
  Future<AddCommonFoodHistoryResponse> addToHistory(AddCommonFoodHistoryRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.addCommonFoodToHistory),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
print(response.body);
      if (response.statusCode == 200) {
        return AddCommonFoodHistoryResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add to history: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Network error: $e');
    }
  }
}