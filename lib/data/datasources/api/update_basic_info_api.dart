import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/update_basic_info_request.dart';

class UpdateBasicInfoApi {
  static const String baseUrl = 'https://hungrxbackend.onrender.com';

  Future<UpdateBasicInfoResponse> updateBasicInfo(UpdateBasicInfoRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/updateBasicInfo'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return UpdateBasicInfoResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update basic info: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating basic info: $e');
    }
  }
}
