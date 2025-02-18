import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';



class PurchaseService {
  static final String _apiKey = Platform.isAndroid 
      ? 'goog_zMbRNkBMFvsDjJcatYRflZMhxgg'
      : 'appl_SeITdhZNEmYswLMWJgsaZjeBIRD';

static Future<void> init() async {
  try {
    await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(PurchasesConfiguration(_apiKey));
    print('RevenueCat SDK initialized successfully');
    
    // Add detailed configuration check
    await debugConfiguration();
  } catch (e) {
    print('Error initializing RevenueCat: $e');
  }
}

static Future<void> debugConfiguration() async {
  try {
    final customerInfo = await Purchases.getCustomerInfo();
    print('⭐ RevenueCat Configuration Debug ⭐');
    print('User ID: ${customerInfo.originalAppUserId}');
    print('Original App User ID: ${customerInfo.originalAppUserId}');
    print('All Entitlements: ${customerInfo.entitlements.all}');
    print('Active Entitlements: ${customerInfo.entitlements.active}');
    
    final offerings = await Purchases.getOfferings();
    print('All Offerings: ${offerings.all}');
    print('Current Offering: ${offerings.current}');
    if (offerings.current != null) {
      print('Packages in current offering: ${offerings.current!.availablePackages.length}');
    }
  } catch (e) {
    print('Debug configuration error: $e');
  }
}

  static Future<List<Package>> getPackages() async {
    try {
      print('Fetching offerings...');
      final offerings = await Purchases.getOfferings();
      
      // Debug information
      print('All offerings: ${offerings.all.keys.join(", ")}');
      print('Current offering: ${offerings.current?.identifier}');
      
      if (offerings.current == null) {
        print('No current offering found');
        return [];
      }

      print('Available packages in current offering: ${offerings.current!.availablePackages.length}');
      
      // Print details of each package
      for (var package in offerings.current!.availablePackages) {
        print('Package: ${package.identifier}');
        print('Product: ${package.storeProduct.identifier}');
        print('Price: ${package.storeProduct.priceString}');
      }

      if (offerings.current!.availablePackages.isEmpty) {
        print('No available packages in current offering');
      }
      
      return offerings.current!.availablePackages;
    } catch (e, stackTrace) {
      print('Error fetching packages: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      print('Attempting to purchase package: ${package.identifier}');
      final purchaseResult = await Purchases.purchasePackage(package);
      print('Purchase successful: ${purchaseResult.entitlements.active}');
      return true;
    } catch (e, stackTrace) {
      print('Error making purchase: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  static Future<bool> isUserPremium() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      final isPremium = customerInfo.entitlements.active.containsKey('premium');
      print('Premium status: $isPremium');
      print('Active entitlements: ${customerInfo.entitlements.active.keys.join(", ")}');
      return isPremium;
    } catch (e) {
      print('Error checking premium status: $e');
      return false;
    }
  }
}