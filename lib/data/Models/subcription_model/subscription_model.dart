import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionModel {
  final String id;
  final String title;
  final String description;
  final String priceString;
  final String duration;
  final Package package;
  final bool isPromoted;
  final String? savings;

  SubscriptionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priceString,
    required this.duration,
    required this.package,
    this.isPromoted = false,
    this.savings,
  });

// Update your SubscriptionModel.fromPackage factory:
factory SubscriptionModel.fromPackage(Package package) {
  final product = package.storeProduct;
  
  // Extract the correct identifiers from the product ID
  String productId = product.identifier;
  print("Creating subscription model for product: $productId");
  
  // Determine package type from identifier
  bool isAnnual = package.identifier.contains('annual') || 
                 productId.contains('annual');
  bool isMonthly = package.identifier.contains('monthly') || 
                  productId.contains('monthly');
  bool isTrial = package.identifier.contains('trial') || 
                package.identifier.contains('weekly') ||
                productId.contains('trial');
  
  // Set duration based on package type
  String duration;
  if (isAnnual) {
    duration = 'year';
  } else if (isMonthly) {
    duration = 'month';
  } else if (isTrial) {
    duration = 'week';
  } else {
    duration = '';
  }
  
  // Determine if this is a promoted package
  bool isPromoted = isAnnual;
  
  // Set savings for annual plan
  String? savings = isAnnual ? 'SAVE 58%' : null;
  
  return SubscriptionModel(
    id: package.identifier,
    title: isAnnual ? 'Annual Plan' : 
           isMonthly ? 'Monthly Plan' : 
           isTrial ? 'Trial Plan' : product.title,
    description: product.description,
    priceString: product.priceString,
    duration: duration,
    package: package,
    isPromoted: isPromoted,
    savings: savings,
  );
}
}