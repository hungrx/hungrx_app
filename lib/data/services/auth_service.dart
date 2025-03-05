import 'package:hungrx_app/data/Models/dashboad_screen/home_screen_model.dart';
import 'package:hungrx_app/data/datasources/api/dashboard_screen/home_screen_api_service.dart';
import 'package:hungrx_app/data/datasources/api/service_api/user_profile_api_service.dart';
import 'package:hungrx_app/data/repositories/auth_screen/onboarding_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hungrx_app/data/repositories/auth_screen/email_signin_repository.dart';
import 'package:hungrx_app/data/repositories/auth_screen/google_auth_repository.dart';
import 'package:hungrx_app/data/repositories/otp_auth_screen/otp_repository.dart';
import 'package:path_provider/path_provider.dart';

class SharedKeys {
  static const String onboardingKey = 'has_seen_onboarding';
  static const String installKey = 'installation_check';
  static const String userIdKey = 'user_id';
  static const String firstTimeKey = 'is_first_time_user';
  static const String lastDialogDateKey = 'last_dialog_date';
  static const String accountCreationDateKey = 'account_creation_date';
  static const String profileCompletionKey = 'profile_completion_status';
  static const String subscriptionStatusKey = 'subscription_status';
  static const String subscriptionLevelKey = 'subscription_level';
}

class AuthService {
  final HomeApiService _homeApiService = HomeApiService();
  final UserSignInRepository _emailSignInRepository = UserSignInRepository();
  final GoogleAuthRepository _googleAuthRepository = GoogleAuthRepository();
  final OtpRepository _otpRepository = OtpRepository();
  final UserProfileApiService _userProfileApiService = UserProfileApiService();
  final OnboardingService _onboardingService = OnboardingService();

  static String userIdKey = 'user_id';
  static String installKey = 'installation_check';
  static const String onboardingKey = 'has_seen_onboarding';
  static const String firstTimeKey = 'is_first_time_user';
  static const String lastDialogDateKey = 'last_dialog_date';
  static const String accountCreationDateKey = 'account_creation_date';
  static const String profileCompletionKey = 'profile_completion_status';
  static const String subscriptionStatusKey = 'subscription_status';
  static const String subscriptionLevelKey = 'subscription_level';

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // Check for fresh install
    if (!prefs.containsKey(installKey)) {
      // New installation - clear everything and set initial state
      await prefs.clear();
      await prefs.setBool(installKey, true);
      await _onboardingService
          .resetOnboarding(); // Ensure onboarding shows for new installs
      await prefs.setBool(firstTimeKey, true);
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(userIdKey);
      final profileComplete = prefs.getBool(profileCompletionKey) ?? false;

      return userId != null && userId.isNotEmpty && profileComplete;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  Future<bool?> checkProfileCompletion(String userId) async {

    
    try {
      final prefs = await SharedPreferences.getInstance();

      // Always check with server to ensure latest status
      final response = await _userProfileApiService.checkUserProfile(userId);

      // ignore: unnecessary_null_comparison
      if (response.status != null) {
        // Cache the profile status
        await prefs.setBool(profileCompletionKey, response.status);
        return response.status;
      }
      return null;
    } catch (e) {
      print('Error checking profile completion: $e');
      return null;
    }
  }
  // Get cached subscription status
  Future<Map<String, dynamic>> getSubscriptionInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'isSubscribed': prefs.getBool(subscriptionStatusKey) ?? false,
        'subscriptionLevel': prefs.getString(subscriptionLevelKey) ?? 'none',
      };
    } catch (e) {
      print('Error getting subscription info: $e');
      return {
        'isSubscribed': false,
        'subscriptionLevel': 'none',
      };
    }
  }

  Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(userIdKey);
    } catch (e) {
      print('Error getting user ID: $e');
      return null;
    }
  }

  Future<HomeData?> fetchHomeData() async {
    try {
      final userId = await getUserId();
      if (userId != null) {
        final isProfileComplete = await checkProfileCompletion(userId);
        if (isProfileComplete ?? false) {
          return await _homeApiService.fetchHomeData(userId);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching home data: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      

      // Save flags before clearing
      final bool installFlag = prefs.getBool(installKey) ?? false;
      final bool onboardingFlag = prefs.getBool(onboardingKey) ?? false;
      final bool firstTimeFlag = prefs.getBool(firstTimeKey) ?? false;
      // final String? lastDialogDate = prefs.getString(lastDialogDateKey);
      final String? accountCreationDate =
          prefs.getString(accountCreationDateKey);

      // Remove specific keys except the preserved ones
      final keysToRemove = prefs.getKeys().where((key) =>
          key != installKey &&
          key != onboardingKey &&
          key != firstTimeKey &&
          key != accountCreationDateKey);

      // Remove all keys except preserved ones
      for (String key in keysToRemove) {
        await prefs.remove(key);
      }

      // Clear authentication states
      await Future.wait([
        _emailSignInRepository.logout(),
        _googleAuthRepository.signOut(),
        _otpRepository.logout(),
      ]);

      // Restore preserved flags and values
      await prefs.setBool(installKey, installFlag);
      await prefs.setBool(onboardingKey, onboardingFlag);
      await prefs.setBool(firstTimeKey, firstTimeFlag);
      // if (lastDialogDate != null) {
      //   await prefs.setString(lastDialogDateKey, lastDialogDate);
      // }
      if (accountCreationDate != null) {
        await prefs.setString(accountCreationDateKey, accountCreationDate);
      }
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
      // final bool onboardingFlag = prefs.getBool(onboardingKey) ?? false;

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
      await _onboardingService
          .resetOnboarding(); // Force onboarding on next login
      await prefs.setBool(firstTimeKey, true);

      await Future.wait([
        _emailSignInRepository.logout(),
        _googleAuthRepository.signOut(),
        _otpRepository.logout(),
      ]);

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
