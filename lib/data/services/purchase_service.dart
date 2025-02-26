import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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
        ..appUserID = null ; // Set this if you need custom ID
         // Set to true if using another payment system
      
      await Purchases.configure(configuration);
      print('✅ RevenueCat SDK initialized successfully');
    } catch (e) {
      print('❌ Error initializing RevenueCat: $e');
      throw Exception('Failed to initialize subscription service: $e');
    }
  }

  /// Identify user to sync purchases across devices
  static Future<void> identifyUser(String userId) async {
    try {
      await Purchases.logIn(userId);
      print('✅ User identified: $userId');
    } catch (e) {
      print('❌ Error identifying user: $e');
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
  static Future<bool> purchasePackage(Package package) async {
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      
      // Check for the specific entitlement ID
      final isPremium = purchaseResult.entitlements.active.containsKey(_entitlementIdentifier);
      debugPrint('Purchase completed - Premium access: $isPremium');
      return isPremium;
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'PURCHASE_CANCELLED':
          debugPrint('⚠️ User cancelled the purchase');
          return false;
        case 'PRODUCT_NOT_FOUND':
          debugPrint('❌ Product not found in store');
          return false;
        default:
          debugPrint('❌ Unknown error: ${e.code} - ${e.message}');
          return false;
      }
    } catch (e) {
      debugPrint('❌ Unexpected error during purchase: $e');
      return false;
    }
  }

  /// Check if User has a Premium Subscription
  static Future<bool> isUserPremium() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      final isPremium = customerInfo.entitlements.active.containsKey(_entitlementIdentifier);
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
      final isPremium = customerInfo.entitlements.active.containsKey(_entitlementIdentifier);
      debugPrint('✅ Purchases restored successfully. Premium status: $isPremium');
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
      
      if (customerInfo.entitlements.active.containsKey(_entitlementIdentifier)) {
        final entitlement = customerInfo.entitlements.active[_entitlementIdentifier]!;
        
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

  /// Debugging Offerings and Packages
  static Future<void> debugOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        debugPrint('⚠️ No current offering found. Set a current offering in RevenueCat.');
      } else {
        debugPrint('✅ Current offering: ${offerings.current!.identifier}');
      }
      
      // Look for the standard offering specifically
      final standardOffering = offerings.getOffering(_offeringIdentifier);
      if (standardOffering != null) {
        debugPrint('✅ Standard offering found: ${standardOffering.identifier}');
        debugPrint('✅ Available packages: ${standardOffering.availablePackages.length}');
      } else {
        debugPrint('⚠️ Standard offering not found');
      }
      
      debugPrint('🔍 DEBUG: All offerings: ${offerings.all.keys}');

      offerings.all.forEach((key, offering) {
        debugPrint('🔍 DEBUG: Offering: $key');
        debugPrint('🔍 DEBUG: Available packages: ${offering.availablePackages.length}');

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
}