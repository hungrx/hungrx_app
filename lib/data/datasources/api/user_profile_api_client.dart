import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_app/data/Models/user_profile_model.dart';

class UserProfileApiClient {
  final String baseUrl = 'https://hungerxapp.onrender.com';

  Future<void> addUserProfile(UserInfoProfileModel userProfile) async {
    // print(userProfile.userId);
    // print(userProfile.name);
    // print(userProfile.gender);
    // print(userProfile.age);
    // print("height cm:${userProfile.heightInCm}");
    // print("height feet:${userProfile.heightInFeet}");
    // print("height in:${userProfile.heightInInches}");
    // print(userProfile.isMetric);
    // print(userProfile.weight);
    // print(userProfile.mealsPerDay);
    // print(userProfile.goal);
    // print(userProfile.targetWeight);
    // print(userProfile.weightGainRate);
    // print(userProfile.activityLevel);

    final url = Uri.parse('$baseUrl/users/addName');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userProfile.toJson()),
      );
// print(response.body);
// print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception('Failed to add user profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add user profile: $e');
    }
  }
}
