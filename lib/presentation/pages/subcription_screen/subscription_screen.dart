import 'package:flutter/material.dart';
import 'package:hungrx_app/data/services/purchase_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  List<Package> _packages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    debugOfferings();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    final packages = await PurchaseService.getPackages();
    setState(() {
      _packages = packages;
      _isLoading = false;
    });
  }
  // Add this temporarily to debug your offerings
static Future<void> debugOfferings() async {
  try {
    final offerings = await Purchases.getOfferings();
    print('DEBUG: Current offering: ${offerings.current}');
    print('DEBUG: All offerings: ${offerings.all}');
  } catch (e) {
    print('DEBUG: Error getting offerings: $e');
  }
}

  Future<void> _purchasePackage(Package package) async {
    setState(() => _isLoading = true);
    
    final success = await PurchaseService.purchasePackage(package);
    
    setState(() => _isLoading = false);
    
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase successful!')),
        );
        Navigator.of(context).pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Plan'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _packages.length,
        itemBuilder: (context, index) {
          final package = _packages[index];
          final product = package.storeProduct;
          
          return Card(
            child: ListTile(
              title: Text(product.title),
              subtitle: Text(product.description),
              trailing: Text(product.priceString),
              onTap: () => _purchasePackage(package),
            ),
          );
        },
      ),
    );
  }
}