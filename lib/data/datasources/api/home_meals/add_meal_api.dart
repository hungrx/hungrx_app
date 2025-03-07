import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/core/utils/api_exception.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/add_meal_request.dart';

class AddMealApi {
  Future<AddMealResponse> addMealToUser(AddMealRequest request) async {
    try {
      const url = ApiConstants.baseUrl + ApiConstants.addConsumedFood;
      final uri = Uri.parse(url);

      if (!uri.hasAuthority) {
        throw Exception('Invalid URL: $url');
      }
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.addConsumedFood),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return AddMealResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw NotFoundException('Food item not found in database');
      } else {
        throw Exception('Failed to add meal: ${response.statusCode}');
      }
    } on FormatException catch (e) {
      throw ApiException(message: e.toString());
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: Unable to connect to server', e);
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error: Unable to connect to server');
      }
      throw Exception('Network error: $e');
    }
  }
}
