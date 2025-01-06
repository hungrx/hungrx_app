// address_direction_button.dart
import 'package:flutter/material.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/nearby_restaurant_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class AddressDirectionButton extends StatelessWidget {
  final NearbyRestaurantModel? restaurant;

  const AddressDirectionButton({
    super.key,
    required this.restaurant,
  });

  Future<void> _launchMaps(List<double> coordinates) async {
    final lat = coordinates[1]; // Latitude is typically the second element
    final lng = coordinates[0]; // Longitude is typically the first element
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                      restaurant?.name??"",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant?.address??"",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${restaurant?.distance.toStringAsFixed(1)} km away',
                          style: const TextStyle(
                            color: AppColors.buttonColors,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
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
                    onTap: () {
                      Navigator.pop(context);
                      _launchMaps(restaurant?.coordinates??[]);
                    },
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.buttonColors,
      child: const Icon(
        Icons.directions,
        color: Colors.black,
      ),
      onPressed: () => _showAddressDialog(context),
    );
  }
}
