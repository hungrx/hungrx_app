import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/profile_screen/update_basic_info_request.dart';

class UpdateBasicInfoApi {
  Future<UpdateBasicInfoResponse> updateBasicInfo(UpdateBasicInfoRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.updateBasicInfo),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
print(response.body);
      if (response.statusCode == 200) {
        return UpdateBasicInfoResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update basic info: ${response.body}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error updating basic info: $e');
    }
  }
}
