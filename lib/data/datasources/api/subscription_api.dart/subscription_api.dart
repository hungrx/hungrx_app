// // lib/data/datasources/api/subscription_api_service.dart
// import 'dart:io';
// import 'package:purchases_flutter/purchases_flutter.dart';

// class SubscriptionApiService {
//   static final String _apiKey = Platform.isAndroid
//       ? 'goog_UWjHgGldvwtlcuhEUqJnNIjsxkK'
//       : 'appl_SeITdhZNEmYswLMWJgsaZjeBIRD';

//   Future<void> initialize() async {
//     try {
//       await Purchases.setLogLevel(LogLevel.debug);
//       await Purchases.configure(PurchasesConfiguration(_apiKey));
//       print('RevenueCat SDK initialized successfully');
//     } catch (e) {
//       print('Error initializing RevenueCat: $e');
//       throw Exception('Failed to initialize subscription service: $e');
//     }
//   }

// // lib/data/datasources/api/subscription_api_service.dart
// // lib/data/datasources/api/subscription_api_service.dart
// Future<List<Package>> fetchPackages() async {
//   try {
//     final offerings = await Purchases.getOfferings();
//     List<Package> allPackages = [];
    
//     // First, try to get packages from the current offering
//     if (offerings.current != null && offerings.current!.availablePackages.isNotEmpty) {
//       print("Using packages from current offering: ${offerings.current!.identifier}");
//       allPackages.addAll(offerings.current!.availablePackages);
//     }
    
//     // Also get packages from specific offerings we want to include
//     final desiredOfferings = ['Monthly', 'Yearly', 'Trail pack'];
    
//     for (final offeringId in desiredOfferings) {
//       if (offerings.all.containsKey(offeringId) && 
//           offerings.all[offeringId]!.availablePackages.isNotEmpty &&
//           !allPackages.any((p) => p.packageType == offerings.all[offeringId]!.availablePackages.first.packageType)) {
//         // Only add if we don't already have a package of this type
//         allPackages.addAll(offerings.all[offeringId]!.availablePackages);
//         print("Added packages from offering: $offeringId");
//       }
//     }
    
//     print("Total packages to display: ${allPackages.length}");
//     return allPackages;
//   } catch (e) {
//     print('Error fetching packages: $e');
//     throw Exception('Failed to fetch subscription packages: $e');
//   }
// }

//   Future<CustomerInfo> purchasePackage(Package package) async {
//     try {
//       final purchaseResult = await Purchases.purchasePackage(package);
//       return purchaseResult;
//     } catch (e) {
//       print('Error purchasing package: $e');
//       throw Exception('Failed to purchase package: $e');
//     }
//   }

//   Future<bool> checkPremiumStatus() async {
//     try {
//       CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//       return customerInfo.entitlements.active.containsKey('premium');
//     } catch (e) {
//       print('Error checking premium status: $e');
//       return false;
//     }
//   }
// }
