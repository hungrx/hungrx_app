import 'package:hungrx_app/data/Models/home_screen_model.dart';
import 'package:hungrx_app/data/datasources/api/home_screen_api_service.dart';
import 'package:hungrx_app/data/datasources/api/user_profile_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hungrx_app/data/repositories/email_signin_repository.dart';
import 'package:hungrx_app/data/repositories/google_auth_repository.dart';
import 'package:hungrx_app/data/repositories/otp_repository.dart';

// thie class is for checking the user is logged in or not , user id is stored in shared prefferance
class AuthService {
  final HomeApiService _homeApiService = HomeApiService();
  final UserSignInRepository _emailSignInRepository = UserSignInRepository();
  final GoogleAuthRepository _googleAuthRepository = GoogleAuthRepository();
  final OtpRepository _otpRepository = OtpRepository();
final UserProfileApiService _userProfileApiService = UserProfileApiService();

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId != null && userId.isNotEmpty) {
      // Check if the user is logged in with any method
      if (await _emailSignInRepository.isLoggedIn() ||
          await _googleAuthRepository.isLoggedIn() ||
          await _otpRepository.isLoggedIn()) {
        return true;
      }
    }

    return false;
  }
 Future<bool> checkProfileCompletion(String userId) async {
    try {
      final response = await _userProfileApiService.checkUserProfile(userId);
      return response.status  == true;
    } catch (e) {
      print('Error checking profile completion: $e');
      return false;
    }
  }


  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<HomeData?> fetchHomeData() async {
    try {
      final userId = await getUserId();
      if (userId != null) {
        return await _homeApiService.fetchHomeData(userId);
      }
      return null;
    } catch (e) {
      print('Error fetching home data: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _emailSignInRepository.logout();
    await _googleAuthRepository.signOut();
    await _otpRepository.logout();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }
}
