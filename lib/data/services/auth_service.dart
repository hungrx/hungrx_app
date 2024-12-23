import 'package:hungrx_app/data/Models/dashboad_screen/home_screen_model.dart';
import 'package:hungrx_app/data/datasources/api/dashboard_screen/home_screen_api_service.dart';
import 'package:hungrx_app/data/datasources/api/service_api/user_profile_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hungrx_app/data/repositories/auth_screen/email_signin_repository.dart';
import 'package:hungrx_app/data/repositories/google_auth_repository.dart';
import 'package:hungrx_app/data/repositories/otp_repository.dart';

// thie class is for checking the user is logged in or not , user id is stored in shared prefferance
class AuthService {
  final HomeApiService _homeApiService = HomeApiService();
  final UserSignInRepository _emailSignInRepository = UserSignInRepository();
  final GoogleAuthRepository _googleAuthRepository = GoogleAuthRepository();
  final OtpRepository _otpRepository = OtpRepository();
final UserProfileApiService _userProfileApiService = UserProfileApiService();


  static const String USER_ID_KEY = 'user_id';
  static const String INSTALL_KEY = 'installation_check';


Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isExistingInstall = prefs.getBool(INSTALL_KEY) ?? false;
    
    if (!isExistingInstall) {
      // New installation - clear any leftover data
      await prefs.clear();
      await prefs.setBool(INSTALL_KEY, true);
    }
  }
Future<bool> isLoggedIn() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(USER_ID_KEY);
    
    if (userId == null || userId.isEmpty) {
      return false;
    }
    return true;
  } catch (e) {
    // On any error, assume user is not logged in
    await logout();
    return false;
  }
}

 Future<bool> checkProfileCompletion(String userId) async {
    try {
      final response = await _userProfileApiService.checkUserProfile(userId);
      return response.status  == true;
    } catch (e) {
      // print('Error checking profile completion: $e');
      return false;
    }
  }


  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_ID_KEY);
  }

  Future<HomeData?> fetchHomeData() async {
    try {
      final userId = await getUserId();
      if (userId != null) {
        return await _homeApiService.fetchHomeData(userId);
      }
      return null;
    } catch (e) {
      // print('Error fetching home data: $e');
      return null;
    }
  }

Future<void> logout() async {
    try {
      await _emailSignInRepository.logout();
      await _googleAuthRepository.signOut();
      await _otpRepository.logout();

      final prefs = await SharedPreferences.getInstance();
      // Clear all data first
      await prefs.clear();
      
      // Reset only the installation check
      await prefs.setBool(INSTALL_KEY, true);
      
      // Ensure USER_ID_KEY is definitely removed
      await prefs.remove(USER_ID_KEY);
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }
}