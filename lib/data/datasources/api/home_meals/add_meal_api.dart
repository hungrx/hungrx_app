import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/utils/api_exception.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/add_meal_request.dart';

class AddMealApi {
  static const String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<AddMealResponse> addMealToUser(AddMealRequest request) async {

       _logRequestDetails(request);
    try {
      if (baseUrl.isEmpty) {
        throw Exception('Base URL cannot be empty');
      }
      const url = '$baseUrl/users/addConsumedFood';
      final uri = Uri.parse(url);

      if (!uri.hasAuthority) {
        throw Exception('Invalid URL: $url');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/users/addConsumedFood'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
print(response.body);

      if (response.statusCode == 200) {
        return AddMealResponse.fromJson(jsonDecode(response.body));
      }else if (response.statusCode == 404) {
        throw NotFoundException('Food item not found in database');
      }
       else {
        throw Exception('Failed to add meal: ${response.statusCode}');
      }

    } on FormatException catch (e) {
      throw ApiException(message: e.toString()  );
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: Unable to connect to server', e);
    }
    catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid URL format: $baseUrl/users/addConsumedFood');
      } else if (e is http.ClientException) {
        print(e);
        throw Exception('Network error: Unable to connect to server');
      }
      throw Exception('Network error: $e');
    }
  }
    void _logRequestDetails(AddMealRequest request) {
    print('Request Details:');
    print('dishId: ${request.dishId}');
    print('mealType: ${request.mealType}');
    print('selectedMeal: ${request.selectedMeal}');
    print('servingSize: ${request.servingSize}');
    print('totalCalories: ${request.totalCalories}');
    print('userId: ${request.userId}');
  }
}
