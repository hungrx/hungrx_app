import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/restuarent_screen/suggested_restaurant_model.dart';

class SuggestedRestaurantsApi {
  final String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<List<SuggestedRestaurantModel>> getSuggestedRestaurants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/suggestions'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true && data['restaurants'] != null) {
          return (data['restaurants'] as List)
              .map((json) => SuggestedRestaurantModel.fromJson(json))
              .toList();
        }
        throw Exception('Invalid data format');
      }
      throw Exception('Failed to fetch suggested restaurants');
    } catch (e) {
      throw Exception('Error fetching suggested restaurants: $e');
    }
  }
}