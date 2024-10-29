import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/weight_entry_model.dart';

class WeightApiService {
  final String baseUrl = 'https://hungerxapp.onrender.com';

  Future<WeightEntry> updateWeight(WeightEntry weightEntry) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/weight-update'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(weightEntry.toJson()),
      );

      if (response.statusCode == 200) {
        return WeightEntry.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update weight: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
