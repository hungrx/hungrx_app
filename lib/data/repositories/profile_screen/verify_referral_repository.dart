import 'package:hungrx_app/data/Models/profile_screen/verify_referral_model.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/verify_referral_api.dart';

class VerifyReferralRepository {
  final VerifyReferralApi _api;

  VerifyReferralRepository({VerifyReferralApi? api})
      : _api = api ?? VerifyReferralApi();

  Future<Map<String, dynamic>> verifyReferralCode(
      String userId, String referralCode) async {
    try {
      // Calculate expiration date (current date + 7 days)
      final expirationDate =
          DateTime.now().add(const Duration(days: 7)).toUtc().toIso8601String();

      final referralData = VerifyReferralModel(
        userId: userId,
        referralCode: referralCode,
        expirationDate: expirationDate,
      );

      return await _api.verifyReferralCode(referralData);
    } catch (e) {
      return {
        'success': false,
        'message': 'Error processing referral verification',
        'data': null,
      };
    }
  }
}
