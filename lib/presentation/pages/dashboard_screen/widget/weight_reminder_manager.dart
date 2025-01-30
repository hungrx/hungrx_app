import 'package:shared_preferences/shared_preferences.dart';

class WeightReminderManager {
  static const String _lastWeightUpdateKey = 'last_weight_update';
  static const String _lastReminderShownKey = 'last_reminder_shown';
  
  static Future<bool> shouldShowReminder() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get last weight update time
    final lastUpdateStr = prefs.getString(_lastWeightUpdateKey);
    final lastUpdate = lastUpdateStr != null 
        ? DateTime.parse(lastUpdateStr)
        : DateTime.now().subtract(const Duration(days: 8)); // Force show if never updated
        
    // Get last reminder shown time
    final lastReminderStr = prefs.getString(_lastReminderShownKey);
    final lastReminder = lastReminderStr != null
        ? DateTime.parse(lastReminderStr)
        : DateTime.now().subtract(const Duration(days: 8));
        
    final now = DateTime.now();
    
    // Show reminder if:
    // 1. More than 7 days since last weight update AND
    // 2. More than 24 hours since last reminder
    return now.difference(lastUpdate).inDays >= 7 &&
           now.difference(lastReminder).inHours >= 24;
  }
  
  static Future<void> updateLastWeightUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastWeightUpdateKey, DateTime.now().toIso8601String());
  }
  
  static Future<void> updateLastReminderShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastReminderShownKey, DateTime.now().toIso8601String());
  }
  
  static Future<DateTime> getLastWeightUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdateStr = prefs.getString(_lastWeightUpdateKey);
    return lastUpdateStr != null 
        ? DateTime.parse(lastUpdateStr)
        : DateTime.now().subtract(const Duration(days: 8));
  }
}