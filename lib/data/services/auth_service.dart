import 'package:hungrx_app/data/Models/home_screen_model.dart';
import 'package:hungrx_app/data/datasources/api/home_screen_api_service.dart';
import 'package:hungrx_app/data/repositories/user_info_profile_repository.dart';
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
  UserProfileRepository? _userProfileRepository;

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

  Future<bool?> isProfileComplete() async {
    print("isprofile complete");
    final isLogged = await isLoggedIn();
    if (!isLogged) return false;

    return await _userProfileRepository?.hasUserProfile();
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<HomeData?> fetchHomeData() async {
    print("fethomedata");
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
