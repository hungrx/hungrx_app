import 'package:shared_preferences/shared_preferences.dart';
import 'package:hungrx_app/data/repositories/email_signin_repository.dart';
import 'package:hungrx_app/data/repositories/google_auth_repository.dart';
import 'package:hungrx_app/data/repositories/otp_repository.dart';
// thie class is for checking the user is logged in or not , user id is stored in shared prefferance
class AuthService {
  final UserSignInRepository _emailSignInRepository = UserSignInRepository();
  final GoogleAuthRepository _googleAuthRepository = GoogleAuthRepository();
  final OtpRepository _otpRepository = OtpRepository();

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

  Future<void> logout() async {
    await _emailSignInRepository.logout();
    await _googleAuthRepository.signOut();
    await _otpRepository.logout();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }
}