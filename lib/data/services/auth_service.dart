import 'package:hungrx_app/data/Models/dashboad_screen/home_screen_model.dart';
import 'package:hungrx_app/data/datasources/api/dashboard_screen/home_screen_api_service.dart';
import 'package:hungrx_app/data/datasources/api/service_api/user_profile_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hungrx_app/data/repositories/auth_screen/email_signin_repository.dart';
import 'package:hungrx_app/data/repositories/auth_screen/google_auth_repository.dart';
import 'package:hungrx_app/data/repositories/otp_auth_screen/otp_repository.dart';

class AuthService {
  final HomeApiService _homeApiService = HomeApiService();
  final UserSignInRepository _emailSignInRepository = UserSignInRepository();
  final GoogleAuthRepository _googleAuthRepository = GoogleAuthRepository();
  final OtpRepository _otpRepository = OtpRepository();
  final UserProfileApiService _userProfileApiService = UserProfileApiService();

  static String userIdKey = 'user_id';
  static String installKey = 'installation_check';

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isExistingInstall = prefs.getBool(installKey) ?? false;

    if (!isExistingInstall) {
      await prefs.clear();
      await prefs.setBool(installKey, true);
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(userIdKey);

      if (userId == null || userId.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      await logout();
      return false;
    }
  }

  Future<bool> checkProfileCompletion(String userId) async {
    try {
      final response = await _userProfileApiService.checkUserProfile(userId);
      return response.status == true;
    } catch (e) {
      // print('Error checking profile completion: $e');
      return false;
    }
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<HomeData?> fetchHomeData() async {
    try {
      final userId = await getUserId();
      if (userId != null) {
        return await _homeApiService.fetchHomeData(userId);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _emailSignInRepository.logout();
      await _googleAuthRepository.signOut();
      await _otpRepository.logout();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await prefs.setBool(installKey, true);
      await prefs.remove(userIdKey);
    } catch (e) {
      rethrow;
    }
  }
}
