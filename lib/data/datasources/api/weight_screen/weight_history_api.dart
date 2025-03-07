import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/constants/api_const/api_constants.dart';
import 'package:hungrx_app/data/Models/weight_screen/weight_history_model.dart';

class WeightHistoryApi {
  Future<WeightHistoryModel> getWeightHistory(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.getWeightHistory),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );
      
      final responseData = json.decode(response.body);
      // print(response);
      if (response.statusCode == 200) {
        if (responseData['status'] == false) {
          throw NoWeightRecordsException(responseData['message']);
        }
        return WeightHistoryModel.fromJson(responseData);
      } else {
        throw ServerException('Failed to load weight history');
      }
    } catch (e) {
      if (e is NoWeightRecordsException) {
        rethrow;
      }
      throw Exception('Error connecting to server: $e');
    }
  }
}

class NoWeightRecordsException implements Exception {
  final String message;
  NoWeightRecordsException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}
