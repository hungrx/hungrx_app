import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedKeys.onboardingKey) ?? false;
  }

  Future<void> setOnboardingAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedKeys.onboardingKey, true);
  }

  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedKeys.onboardingKey, false);
  }
}
