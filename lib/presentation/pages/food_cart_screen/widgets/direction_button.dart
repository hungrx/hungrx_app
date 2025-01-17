import 'package:flutter/material.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/nearby_restaurant_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class AddressDirectionDialog extends StatelessWidget {
  final NearbyRestaurantModel? restaurant;

  const AddressDirectionDialog({
    super.key,
    required this.restaurant,
  });

  Future<void> _launchMaps(String address) async {
    if (address.isEmpty) {
      debugPrint('Address is empty. Cannot launch maps.');
      return;
    }

    final cleanAddress = address.trim().replaceAll(RegExp(r'\s+'), ' ');
    final encodedAddress = Uri.encodeComponent(cleanAddress);
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$encodedAddress';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch maps';
      }
    } catch (e) {
      debugPrint('Error launching maps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Restaurant Location',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.grey[800],
              child: ListTile(
                title: Text(
                  restaurant?.restaurantName ?? "Unknown Restaurant",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant?.address ?? "Address not available",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    if (restaurant?.distance != null)
                      Text(
                        '${restaurant?.distance.toStringAsFixed(1)} km away',
                        style: const TextStyle(
                          color: AppColors.buttonColors,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                trailing: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _launchMaps(restaurant?.address ?? "");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.buttonColors.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.directions,
                      color: AppColors.buttonColors,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(
                  color: AppColors.buttonColors,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// To show this dialog, use:
// showDialog(
//   context: context,
//   builder: (BuildContext context) => AddressDirectionDialog(
//     restaurant: yourNearbyRestaurantModelInstance,
//   ),
// );
