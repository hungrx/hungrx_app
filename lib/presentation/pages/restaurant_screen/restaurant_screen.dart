import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/restaurent_menu_screen.dart';
import 'package:hungrx_app/presentation/widgets/header_section.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  RestaurantScreenState createState() => RestaurantScreenState();
}

class RestaurantScreenState extends State<RestaurantScreen> {
  String selectedFoodType = 'Non-Veg Food';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildNearbyRestaurants(),
            _buildFoodTypeSelector(),
            Expanded(child: _buildRestaurantList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const HeaderSection(
      title: 'Restaurants',
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.buttonColors),
        ),
        child: const TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Find the foods under your daily kcal...',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyRestaurants() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Nearby Restaurant',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.map, size: 18),
            label: const Text('Show Map'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: AppColors.buttonColors,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              // Implement show map functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFoodTypeSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['Veg Food', 'Non-Veg Food', 'Mixed'].map((type) {
          return GestureDetector(
            onTap: () => setState(() => selectedFoodType = type),
            child: Text(
              type,
              style: TextStyle(
                color: selectedFoodType == type
                    ? AppColors.buttonColors
                    : Colors.grey,
                fontWeight: selectedFoodType == type
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRestaurantList() {
    return ListView.builder(
      itemCount: 6, // Example count
      itemBuilder: (context, index) {
        return RestaurantItem(
          ontap: () {},
          name: 'Mc Donald\'s',
          imageUrl:
              'https://www.nrn.com/sites/nrn.com/files/Mcd%20Drive%20Thru.jpg', // Replace with actual image URL
          rating: 4.2,
          address: '541 6th Ave, New York',
          distance: '0.2 km',
        );
      },
    );
  }
}

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
              child: Image.asset(
                'assets/images/maclog.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.buttonColors,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.directions, color: Colors.black, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
