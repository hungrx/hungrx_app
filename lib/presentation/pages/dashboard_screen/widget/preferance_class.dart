import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String firstTimeKey = 'is_first_time_user';
  static const String lastDialogDateKey = 'last_dialog_date';
  static const String accountCreationDateKey = 'account_creation_date';

  final SharedPreferences _prefs;

  AppPreferences(this._prefs);

  // First time user methods
  String formatDate(String date, {bool toStorage = true}) {
    try {
      if (toStorage) {
        // Convert DD/MM/YYYY to YYYY-MM-DD
        if (date.contains('/')) {
          final parts = date.split('/');
          if (parts.length == 3) {
            return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
          }
        }
      } else {
        // Convert YYYY-MM-DD to DD/MM/YYYY
        if (date.contains('-')) {
          final parts = date.split('-');
          if (parts.length == 3) {
            return '${parts[2]}/${parts[1]}/${parts[0]}';
          }
        }
      }
      return date;
    } catch (e) {
      print('Date format error: $e');
      return date;
    }
  }

  // First time user methods
  bool isFirstTimeUser() {
    return _prefs.getBool(firstTimeKey) ?? true;
  }

  void setFirstTimeUser(bool value) {
    _prefs.setBool(firstTimeKey, value);
  }

  // Dialog date methods
  String? getLastDialogDate() {
    return _prefs.getString(lastDialogDateKey);
  }

  void setLastDialogDate(String date) {
    final formattedDate = formatDate(date);
    print('Setting last dialog date to: $formattedDate (original: $date)');
    _prefs.setString(lastDialogDateKey, formattedDate);
  }

  void clearLastDialogDate() {
    _prefs.remove(lastDialogDateKey);
  }

  // Account creation date methods
  String? getAccountCreationDate() {
    final date = _prefs.getString(accountCreationDateKey);
    return date != null ? formatDate(date, toStorage: false) : null;
  }

  void setAccountCreationDate(String date) {
    final formattedDate = formatDate(date);
    print('Setting account creation date: $formattedDate (original: $date)');
    _prefs.setString(accountCreationDateKey, formattedDate);
  }

  bool hasShownDialogToday() {
    final lastShown = getLastDialogDate();
    if (lastShown == null) return false;

    final today = DateTime.now().toIso8601String().split('T')[0];
    return lastShown == today;
  }

  void printAllPreferences() {
    print('First time user: ${_prefs.getBool(firstTimeKey)}');
    print('Last dialog date: ${_prefs.getString(lastDialogDateKey)}');
    print('Account creation date: ${_prefs.getString(accountCreationDateKey)}');
  }
}
