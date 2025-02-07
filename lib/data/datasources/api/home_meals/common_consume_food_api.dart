import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/common_food/common_food_request.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/common_food/common_food_responce.dart';

class CommonFoodApi {
  Future<CommonFoodResponse> addCommonFood(CommonFoodRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.addConsumedCommonFood),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );
      print(response.body);
print(request.userId);
      if (response.statusCode == 200) {
        return CommonFoodResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add common food: ${response.body}');
      }
    } catch (e) {
      print(e);
      throw Exception('Network error: $e');
    }
  }
}
