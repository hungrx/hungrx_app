  import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/water_screen/delete_water_response.dart';

class DeleteWaterApi {
  static const String _baseUrl = 'https://hungrxbackend.onrender.com';

  Future<DeleteWaterResponse> deleteWaterEntry({
    required String userId,
    required String date,
    required String entryId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/users/removeWaterEntry'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'date': date,
          'entryId': entryId,
        }),
      );

      if (response.statusCode == 200) {
        return DeleteWaterResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to delete water entry: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting water entry: $e');
    }
  }
}