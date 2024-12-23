import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/presentation/blocs/nearby_restaurant/nearby_restaurant_bloc.dart';
import 'package:hungrx_app/presentation/blocs/nearby_restaurant/nearby_restaurant_event.dart';
import 'package:hungrx_app/presentation/blocs/nearby_restaurant/nearby_restaurant_state.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_bloc.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_event.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_state.dart';
import 'package:hungrx_app/presentation/pages/restaurant_screen/widgets/restaurant_tile.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Initialize nearby restaurants data
    context.read<NearbyRestaurantBloc>().add(FetchNearbyRestaurants());
     context.read<SuggestedRestaurantsBloc>().add(FetchSuggestedRestaurants());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _initializeData();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(),
                      _buildNearbyRestaurantsSection(),
                      _buildSuggestedRestaurantsSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
             IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
          ),
        const Text(
          'Restaurants',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () => context.push('/restarantSearch'),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(30),
          ),
          child: const IgnorePointer(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search restaurants...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyRestaurantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Nearby Restaurants',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        BlocBuilder<NearbyRestaurantBloc, NearbyRestaurantState>(
          builder: (context, state) {
            if (state is NearbyRestaurantLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is NearbyRestaurantError) {
              return _buildErrorState(state.message);
            } else if (state is NearbyRestaurantLoaded) {
              if (state.restaurants.isEmpty) {
                return _buildEmptyState('No nearby restaurants found');
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = state.restaurants[index];
                  return RestaurantItem(
                    ontap: () => _onRestaurantTap(),
                    name: restaurant.name,
                    imageUrl: 'https://via.placeholder.com/150',
                    rating:
                        '${(restaurant.distance / 1000).toStringAsFixed(1)} km',
                    address: restaurant.address,
                    distance:
                        '${(restaurant.distance / 1000).toStringAsFixed(1)} km',
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
Widget _buildSuggestedRestaurantsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Text(
          'Suggested For You',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      BlocBuilder<SuggestedRestaurantsBloc, SuggestedRestaurantsState>(
        builder: (context, state) {
          if (state is SuggestedRestaurantsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SuggestedRestaurantsError) {
            return _buildErrorState(state.message);
          } else if (state is SuggestedRestaurantsLoaded) {
            if (state.restaurants.isEmpty) {
              return _buildEmptyState('No suggested restaurants available');
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = state.restaurants[index];
                return RestaurantItem(
                  ontap: () {
                    _onRestaurantTap();
                  },
                  name: restaurant.name,
                  imageUrl: 'https://via.placeholder.com/150',
                  rating: "N/A",
                  address: restaurant.address ?? 'Address not available',
                  distance: restaurant.distance != null 
                    ? '${(restaurant.distance! / 1000).toStringAsFixed(1)} km'
                    : 'Distance not available',
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    ],
  );
}

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Icon(
            //   Icons.error_outline,
            //   color: Colors.red,
            //   size: 48,
            // ),
            // const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant,
              color: Colors.grey,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _onRestaurantTap() {
    context.push('/menu');
  }
}

// lib/presentation/pages/restaurant/widgets/restaurant_item.dart

