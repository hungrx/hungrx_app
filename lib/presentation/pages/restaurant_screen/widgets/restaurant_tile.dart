import 'package:flutter/material.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/restaurent_menu_screen.dart';
import 'package:image_network/image_network.dart';

class RestaurantItem extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double rating;
  final String address;
  final String distance;
  final void Function()? ontap;

  const RestaurantItem(
      {super.key,
      required this.name,
      required this.imageUrl,
      required this.rating,
      required this.address,
      required this.distance,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RestaurantMenuScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageNetwork(
                image: imageUrl,
                width: 80,
                height: 80,
                duration: 1000,
                curve: Curves.easeIn,
                onPointer: true,
                debugPrint: false,
                fullScreen: false,
                fitWeb: BoxFitWeb.cover,
                borderRadius: BorderRadius.circular(8),
                onLoading: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
                onError: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: 24,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'No image',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      Text(rating.toString(),
                          style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                  Text(address,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(distance,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
