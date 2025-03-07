import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:hungrx_app/data/Models/timezone/timezone_model.dart';
import 'package:hungrx_app/data/datasources/api/timezone/timezone_api.dart';

class TimezoneRepository {
  final TimezoneApi _api;

  TimezoneRepository(this._api);

  /// Detects the device’s IANA timezone for India and USA.
  /// For India, we check if the offset is exactly +5:30.
  /// For USA, we match common timezone abbreviations.
  String detectTimeZone() {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;
    final abbreviation = now.timeZoneName;

    // Check for India
    if (offset == const Duration(hours: 5, minutes: 30)) {
      return 'Asia/Kolkata';
    }

    // For USA, use common abbreviations.
    switch (abbreviation) {
      case 'AKST': // Alaska Standard Time
      case 'AKDT': // Alaska Daylight Time
        return 'America/Anchorage';
      case 'HST':  // Hawaii Standard Time (Hawaii doesn't observe DST)
        return 'Pacific/Honolulu';
      case 'EST': // Eastern Standard Time
      case 'EDT': // Eastern Daylight Time
        return 'America/New_York';
      case 'CST': // Central Standard Time
      case 'CDT': // Central Daylight Time
        return 'America/Chicago';
      case 'MDT': // Mountain Daylight Time
        return 'America/Denver';
      case 'MST': // Mountain Standard Time
        // Both Denver and Phoenix show 'MST' in winter.
        // However, Phoenix (America/Phoenix) stays on MST year-round,
        // so if DST is in effect (and yet abbreviation is still MST),
        // we assume the device is in Phoenix.
        return 'America/Phoenix';
      default:
        // Fallback: if offset is negative (likely USA), return Eastern;
        // otherwise default to India.
        return offset.isNegative ? 'America/New_York' : 'Asia/Kolkata';
    }
  }

  /// Updates the user timezone by detecting the current timezone,
  /// initializing timezone data, and sending the timezone info via API.
  Future<TimezoneModel> updateUserTimezone(String userId) async {
    try {
      // Initialize the timezone database.
      tz.initializeTimeZones();

      // Detect timezone based on device settings.
      final detectedTimeZone = detectTimeZone();

      final response = await _api.updateTimezone(userId, detectedTimeZone);

      if (response['success'] == true) {
        return TimezoneModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to update timezone');
      }
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Formats the given [dateTime] according to the provided [timezoneName].
  String formatTimeWithTimezone(String timezoneName, DateTime dateTime) {
    try {
      final location = tz.getLocation(timezoneName);
      final tzDateTime = tz.TZDateTime.from(dateTime, location);
      final formatter = DateFormat.yMd().add_jms();
      return formatter.format(tzDateTime);
    } catch (e) {
      return "Error formatting date";
    }
  }
}
