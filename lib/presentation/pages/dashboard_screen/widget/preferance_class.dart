import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AppPreferences {
  static const String firstTimeKey = 'is_first_time_user';
  static const String lastDialogDateKey = 'last_dialog_date';
  static const String accountCreationDateKey = 'account_creation_date';

  final SharedPreferences _prefs;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  AppPreferences(this._prefs);

  // First time user methods
  bool isFirstTimeUser() {
    return _prefs.getBool(firstTimeKey) ?? true;
  }

  Future<void> setFirstTimeUser(bool value) async {
    await _prefs.setBool(firstTimeKey, value);
  }

  // Dialog date methods
  String? getLastDialogDate() {
    final storedDate = _prefs.getString(lastDialogDateKey);
    return storedDate;
  }

  Future<void> setLastDialogDate(String date) async {
    try {
      // Ensure the date is in dd/MM/yyyy format
      DateTime parsedDate;
      if (date.contains('-')) {
        // Parse ISO format
        parsedDate = DateTime.parse(date);
      } else {
        // Parse dd/MM/yyyy format
        parsedDate = _dateFormat.parse(date);
      }
      
      // Store in dd/MM/yyyy format
      final formattedDate = _dateFormat.format(parsedDate);
      await _prefs.setString(lastDialogDateKey, formattedDate);
    } catch (e) {
      // Store original if parsing fails
      await _prefs.setString(lastDialogDateKey, date);
    }
  }

  Future<void> clearLastDialogDate() async {
    await _prefs.remove(lastDialogDateKey);
  }

  // Account creation date methods
  String? getAccountCreationDate() {
    return _prefs.getString(accountCreationDateKey);
  }

  Future<void> setAccountCreationDate(String date) async {
    try {
      // Always store in dd/MM/yyyy format
      DateTime parsedDate;
      if (date.contains('-')) {
        parsedDate = DateTime.parse(date);
      } else {
        parsedDate = _dateFormat.parse(date);
      }
      
      final formattedDate = _dateFormat.format(parsedDate);
      await _prefs.setString(accountCreationDateKey, formattedDate);
    } catch (e) {
      await _prefs.setString(accountCreationDateKey, date);
    }
  }

  bool hasShownDialogToday() {
    final lastShown = getLastDialogDate();
    if (lastShown == null) return false;

    final today = _dateFormat.format(DateTime.now());
    final isShown = lastShown == today;
    return isShown;
  }

  void printAllPreferences() {
  }
}