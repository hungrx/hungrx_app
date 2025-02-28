import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PurchaseService {
  
  static String get _apiKey => Platform.isIOS
      ? "appl_SeITdhZNEmYswLMWJgsaZjeBIRD"
      : "goog_UWjHgGldvwtlcuhEUqJnNIjsxkK";

  // Define your offering and entitlement identifiers to avoid typos
  static const String _offeringIdentifier = "standard";
  static const String _entitlementIdentifier = "Premium";

  /// Initialize RevenueCat SDK
  static Future<void> initialize() async {
    try {
      await Purchases.setLogLevel(LogLevel.debug);

      // Configure with additional options
      final configuration = PurchasesConfiguration(_apiKey)
        ..appUserID = null; // Set this if you need custom ID
      // Set to true if using another payment system

      await Purchases.configure(configuration);
      // print('✅ RevenueCat SDK initialized successfully');
      Purchases.addCustomerInfoUpdateListener((info) async {
        // You can set up a listener here to get transaction data when
        // CustomerInfo is updated after a purchase
        debugPrint('CustomerInfo updated, may contain new purchases');
      });
    } catch (e) {
      // print('❌ Error initializing RevenueCat: $e');
      throw Exception('Failed to initialize subscription service: $e');
    }
  }

  /// Identify user to sync purchases across devices
  static Future<void> identifyUser(String userId) async {
    try {
      await Purchases.logIn(userId);
      // print('✅ User identified: $userId');
    } catch (e) {
      // print('❌ Error identifying user: $e');
      throw Exception('Failed to identify user: $e');
    }
  }

  static Future<List<Package>> getPackages() async {
    try {
      final offerings = await Purchases.getOfferings();

      // Try to get packages from the standard offering
      if (offerings.current != null &&
          offerings.current!.identifier == _offeringIdentifier) {
        debugPrint('✅ Found standard offering');
        return offerings.current!.availablePackages;
      }

      // Fallback: try to get the offering directly by ID
      final standardOffering = offerings.getOffering(_offeringIdentifier);
      if (standardOffering != null) {
        debugPrint('✅ Found standard offering by ID');
        return standardOffering.availablePackages;
      }

      // Fallback: return packages from any available offering
      if (offerings.all.isNotEmpty) {
        final firstOffering = offerings.all.values.first;
        debugPrint('⚠️ Using fallback offering: ${firstOffering.identifier}');
        return firstOffering.availablePackages;
      }

      debugPrint('⚠️ No offerings found');
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching packages: $e');
      return [];
    }
  }

  /// Purchase a Subscription Package
  static Future<Map<String, dynamic>> purchasePackage(Package package) async {
    try {
      // Store product details before purchase
      final productId = package.storeProduct.identifier;
      final offerType = package.identifier;
      final priceInLocalCurrency = package.storeProduct.price.toString();
      final currencyCode = package.storeProduct.currencyCode;

      // Make the purchase
      final purchaseResult = await Purchases.purchasePackage(package);

      // Check for the specific entitlement ID
      final isPremium = purchaseResult.entitlements.active
          .containsKey(_entitlementIdentifier);

      // Get the RevenueCat user ID
      final rcAppUserId = purchaseResult.originalAppUserId;

      // Create a transaction details map
      final transactionDetails = {
        'success': isPremium,
        'userId': '', // You need to supply this from your auth system
        'rcAppUserId': rcAppUserId,
        'productId': productId,
        'offerType': offerType,
        'priceInLocalCurrency': priceInLocalCurrency,
        'currencyCode': currencyCode,
      };

      // We'll need to get transaction ID or purchase token separately
      // as it's not directly accessible in the purchase result
      if (Platform.isAndroid) {
        // For Android, we need to extract the purchase token
        // This requires some additional work - see extractPurchaseToken method
        final purchaseToken = await _extractPurchaseToken(productId);
        if (purchaseToken != null) {
          transactionDetails['purchaseToken'] = purchaseToken;
        }
      } else if (Platform.isIOS) {
        // For iOS, try to get the transaction ID
        final transactionId = await _extractTransactionId();
        if (transactionId != null) {
          transactionDetails['transactionId'] = transactionId;
        }
      }

      debugPrint('Purchase completed - Premium access: $isPremium');
      debugPrint('Transaction details: $transactionDetails');

      return transactionDetails;
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'PURCHASE_CANCELLED':
          debugPrint('⚠️ User cancelled the purchase');
          return {'success': false, 'error': 'PURCHASE_CANCELLED'};
        case 'PRODUCT_NOT_FOUND':
          debugPrint('❌ Product not found in store');
          return {'success': false, 'error': 'PRODUCT_NOT_FOUND'};
        default:
          debugPrint('❌ Unknown error: ${e.code} - ${e.message}');
          return {'success': false, 'error': e.code};
      }
    } catch (e) {
      debugPrint('❌ Unexpected error during purchase: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<String?> _extractPurchaseToken(String productId) async {
    try {
      // This approach uses the getCustomerInfo to see if we can find the transaction
      // final customerInfo = await Purchases.getCustomerInfo();

      // Check purchase details in debug logs
      // In a real implementation, you might use a platform channel to access
      // the Android BillingClient directly to get the purchase token

      // For now, return a placeholder or null
      return null; // In production, you'd implement a real extraction
    } catch (e) {
      debugPrint('Error extracting purchase token: $e');
      return null;
    }
  }

  static Future<String?> _extractTransactionId() async {
    try {
      // On iOS, we'd need to check the receipt or use an iOS-specific method
      // This is a placeholder for a real implementation
      return null;
    } catch (e) {
      debugPrint('Error extracting transaction ID: $e');
      return null;
    }
  }

  /// Check if User has a Premium Subscription
  static Future<bool> isUserPremium() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      final isPremium =
          customerInfo.entitlements.active.containsKey(_entitlementIdentifier);
      debugPrint('User premium status: $isPremium');
      return isPremium;
    } catch (e) {
      debugPrint('❌ Error checking premium status: $e');
      return false;
    }
  }

  /// Get User's RevenueCat Identifier
  static Future<String?> getUserIdentifier() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.originalAppUserId;
    } catch (e) {
      debugPrint('❌ Error getting user identifier: $e');
      return null;
    }
  }

  /// Restore Purchases for Existing Users
  static Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      final isPremium =
          customerInfo.entitlements.active.containsKey(_entitlementIdentifier);
      debugPrint(
          '✅ Purchases restored successfully. Premium status: $isPremium');
      return isPremium;
    } catch (e) {
      debugPrint('❌ Error restoring purchases: $e');
      return false;
    }
  }

  /// Get active subscription details
  static Future<Map<String, dynamic>?> getActiveSubscriptionDetails() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();

      if (customerInfo.entitlements.active
          .containsKey(_entitlementIdentifier)) {
        final entitlement =
            customerInfo.entitlements.active[_entitlementIdentifier]!;

        return {
          'productIdentifier': entitlement.productIdentifier,
          'latestPurchaseDate': entitlement.latestPurchaseDate,
          'expirationDate': entitlement.expirationDate,
          'willRenew': entitlement.willRenew,
        };
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting subscription details: $e');
      return null;
    }
  }

  /// Open system subscription management screen
  static Future<void> manageSubscriptions() async {
    // Choose URL based on the platform
    final Uri? url = Platform.isIOS
        ? Uri.parse('https://apps.apple.com/account/subscriptions')
        : Platform.isAndroid
            ? Uri.parse('https://play.google.com/store/account/subscriptions')
            : null;

    if (url == null) {
      print('Subscription management is not supported on this platform.');
      return;
    }

    // Attempt to launch the URL
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch subscription management page.');
    }
  }

  /// Debugging Offerings and Packages
  static Future<void> debugOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        debugPrint(
            '⚠️ No current offering found. Set a current offering in RevenueCat.');
      } else {
        debugPrint('✅ Current offering: ${offerings.current!.identifier}');
      }

      // Look for the standard offering specifically
      final standardOffering = offerings.getOffering(_offeringIdentifier);
      if (standardOffering != null) {
        debugPrint('✅ Standard offering found: ${standardOffering.identifier}');
        debugPrint(
            '✅ Available packages: ${standardOffering.availablePackages.length}');
      } else {
        debugPrint('⚠️ Standard offering not found');
      }

      debugPrint('🔍 DEBUG: All offerings: ${offerings.all.keys}');

      offerings.all.forEach((key, offering) {
        debugPrint('🔍 DEBUG: Offering: $key');
        debugPrint(
            '🔍 DEBUG: Available packages: ${offering.availablePackages.length}');

        for (var package in offering.availablePackages) {
          debugPrint('🔍 Package: ${package.identifier}');
          debugPrint('🔍 Product: ${package.storeProduct.identifier}');
          debugPrint('🔍 Title: ${package.storeProduct.title}');
          debugPrint('🔍 Price: ${package.storeProduct.priceString}');
          debugPrint('🔍 Description: ${package.storeProduct.description}');
        }
      });
    } catch (e) {
      debugPrint('❌ DEBUG: Error getting offerings: $e');
    }
  }

  static Map<String, String> extractTransactionDetailsFromLogs(
      String logOutput) {
    final Map<String, String> details = {};

    // Extract purchase token
    final purchaseTokenRegex = RegExp(r'purchaseToken: ([^\s]+)');
    final purchaseTokenMatch = purchaseTokenRegex.firstMatch(logOutput);
    if (purchaseTokenMatch != null && purchaseTokenMatch.groupCount >= 1) {
      details['purchaseToken'] = purchaseTokenMatch.group(1)!;
    }

    // Extract order ID (transaction ID)
    final orderIdRegex = RegExp(r'orderId: ([^\s,]+)');
    final orderIdMatch = orderIdRegex.firstMatch(logOutput);
    if (orderIdMatch != null && orderIdMatch.groupCount >= 1) {
      details['transactionId'] = orderIdMatch.group(1)!;
    }

    // Extract product ID
    final productIdRegex = RegExp(r'productIds: \[([^\]]+)\]');
    final productIdMatch = productIdRegex.firstMatch(logOutput);
    if (productIdMatch != null && productIdMatch.groupCount >= 1) {
      details['productId'] = productIdMatch.group(1)!;
    }

    return details;
  }
}
