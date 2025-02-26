import 'dart:io';

class EULAHelper {
  // URLs for your custom EULA/Terms of Service
  static const String customEulaUrl = 'https://www.hungrx.com/terms-and-conditions.html';

  // Apple's standard EULA URL
  static const String appleEulaUrl =
      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';

  static String getEulaUrl() {
    if (Platform.isIOS) {
      // If using Apple's standard EULA
      return appleEulaUrl;

      // If using custom EULA
      // return customEulaUrl;
    } else {
      // For Android, always use your custom EULA
      return customEulaUrl;
    }
  }

  static String getEulaText() {
    if (Platform.isIOS) {
      return '''
By using this app, you agree to the terms and conditions outlined in the End User License Agreement (EULA). This application is licensed under Apple's Standard EULA.

• Auto-renewable subscription terms:
  - Payment will be charged to your Apple ID account at confirmation of purchase
  - Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period
  - Account will be charged for renewal within 24-hours prior to the end of the current period
  - You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase
''';
    } else {
      return '''
By using this app, you agree to our Terms of Service and Privacy Policy.

• Subscription terms:
  - Payment will be charged to your Google Play account at confirmation of purchase
  - Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period
  - Account will be charged for renewal within 24-hours prior to the end of the current period
  - You can manage and cancel your subscriptions in your Google Play account settings
''';
    }
  }
}