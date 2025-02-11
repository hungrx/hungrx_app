import 'package:hungrx_app/data/Models/dashboad_screen/home_screen_model.dart';
import 'package:hungrx_app/data/datasources/api/dashboard_screen/home_screen_api_service.dart';
import 'package:hungrx_app/data/datasources/api/service_api/user_profile_api_service.dart';
import 'package:hungrx_app/data/datasources/api/weight_screen/weight_history_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hungrx_app/data/repositories/auth_screen/email_signin_repository.dart';
import 'package:hungrx_app/data/repositories/auth_screen/google_auth_repository.dart';
import 'package:hungrx_app/data/repositories/otp_auth_screen/otp_repository.dart';
import 'package:path_provider/path_provider.dart';

class AuthService {
  final HomeApiService _homeApiService = HomeApiService();
  final UserSignInRepository _emailSignInRepository = UserSignInRepository();
  final GoogleAuthRepository _googleAuthRepository = GoogleAuthRepository();
  final OtpRepository _otpRepository = OtpRepository();
  final UserProfileApiService _userProfileApiService = UserProfileApiService();

  static String userIdKey = 'user_id';
  static String installKey = 'installation_check';
  static const String onboardingKey = 'has_seen_onboarding';

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

  Future<bool?> checkProfileCompletion(String userId) async {
    try {
      final response = await _userProfileApiService.checkUserProfile(userId);
      return response.status;
    } on ServerException {
      // Return null instead of false for server errors
      return null;
    } catch (e) {
      print('Error checking profile completion: $e');
      return null;
    }
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<HomeData?> fetchHomeData() async {
    try {
      final userId = await getUserId();
      print("userId :$userId");
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
      final prefs = await SharedPreferences.getInstance();

      // Save flags before clearing
      final bool installFlag = prefs.getBool(installKey) ?? false;
      final bool onboardingFlag = prefs.getBool(onboardingKey) ?? false;

      // Remove specific keys instead of clearing everything
      final keysToRemove = prefs
          .getKeys()
          .where((key) => key != installKey && key != onboardingKey);

      // Remove all keys except installation and onboarding
      for (String key in keysToRemove) {
        await prefs.remove(key);
      }

      // Clear authentication states
      await Future.wait([
        _emailSignInRepository.logout(),
        _googleAuthRepository.signOut(),
        _otpRepository.logout(),
      ]);

      // Restore flags
      await prefs.setBool(installKey, installFlag);
      await prefs.setBool(onboardingKey, onboardingFlag);
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }

  Future<void> handleAccountDeletion() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save flags before clearing
      final bool installFlag = prefs.getBool(installKey) ?? false;
      final bool onboardingFlag = prefs.getBool(onboardingKey) ?? false;

      // Clear all SharedPreferences
      await prefs.clear();

      // Clear authentication states
      await Future.wait([
        _emailSignInRepository.logout(),
        _googleAuthRepository.signOut(),
        _otpRepository.logout(),
      ]);

      // Restore flags
      await prefs.setBool(installKey, installFlag);
      await prefs.setBool(onboardingKey, onboardingFlag);

      await _clearAppCache();
    } catch (e) {
      print('Error during account deletion: $e');
      rethrow;
    }
  }

  Future<void> _clearAppCache() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final cacheDir = await getTemporaryDirectory();

      // Clear app documents directory
      if (await appDir.exists()) {
        await for (var entity in appDir.list(recursive: true)) {
          if (await entity.exists()) {
            await entity.delete(recursive: true);
          }
        }
      }

      // Clear cache directory
      if (await cacheDir.exists()) {
        await for (var entity in cacheDir.list(recursive: true)) {
          if (await entity.exists()) {
            await entity.delete(recursive: true);
          }
        }
      }
    } catch (e) {
      print('Error clearing app cache: $e');
      // Don't rethrow as this is a cleanup operation
    }
  }
}
