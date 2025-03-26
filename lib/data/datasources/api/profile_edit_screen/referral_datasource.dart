import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/core/errors/exceptions.dart';
import 'package:hungrx_app/data/Models/profile_screen/referral_model.dart';

class ReferralDataSource {
  final http.Client client;

  ReferralDataSource({required this.client});

  Future<ReferralModel> generateReferralCode(String userId) async {
    try {
      final response = await client.post(
        Uri.parse('https://hungrxbackend.onrender.com/users/generateRef'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': "67b44ab88f2b4412e7b9f55c",
        }),
      );

      print(response.body);

      if (response.statusCode == 200) {
        return ReferralModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException('Failed to generate referral code');
      }
    } catch (e) {
      throw ServerException('Failed to connect to server: $e');
    }
  }
}
